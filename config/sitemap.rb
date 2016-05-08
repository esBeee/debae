# This is the configuration for the sitemap_generator gem
# (learn more at https://github.com/kjvarga/sitemap_generator).
#
# Let it create a new sitemap by running:
#
# $ rake sitemap:refresh
#
# or with
#
# $ rake sitemap:refresh:no_ping
#
# if you don't want to alert search engines taht a new sitemap
# is available (recommended in development)
#
# This will create the files in the folder public/
# Note: It is not configured to run automatically, right now.
# That's why the gem is only available in development.

# Set the host name for URL creation.
SitemapGenerator::Sitemap.default_host = "https://debae.io"

# Configure upload to S3.
#
fog_directory = Rails.env.production? ? "debae" : "debae-dev"
# store on S3 using Fog (pass in configuration values as shown above if needed)
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(
  fog_provider: "AWS",
  fog_directory: fog_directory,
  fog_region: "eu-central-1"
)
# inform the map cross-linking where to find the other maps
SitemapGenerator::Sitemap.sitemaps_host = "http://#{fog_directory}.s3-website.eu-central-1.amazonaws.com/"
# pick a namespace within your bucket to organize your maps
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

# Finally collect routes.
SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
  add '/', priority: 1
  add '/about', priority: 0.5

  priorities = [] # Collect all priorities (Not required! Just to check that the values are as exopected)

  # Add the paths to each statement.
  Statement.find_each do |statement|
    priority = statement.score ? 0.25 * statement.score : 0
    priority += 0.75 if statement.top_level

    if priority > 1
      Kazus.log :error, "While generating sitemap: priority is greater than 1", statement: statement, priority: priority
      priority = 1
    end

    if priority < 0
      Kazus.log :error, "While generating sitemap: priority is less than 0", statement: statement, priority: priority
      priority = 0
    end

    priorities << priority

    add statement_path(statement), lastmod: statement.updated_at, priority: priority
  end

  Kazus.log :unknown, "Sitemap successfully refreshed (find me in config/sitemap.rb)", priorities: priorities
end
