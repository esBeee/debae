# Read more about the configuration options here
# http://www.rubydoc.info/gems/paperclip/Paperclip/Storage/S3

Paperclip::Attachment.default_options[:url] = ":s3_domain_url"

# Set the path within the bucket the object will be uploaded to.
path = "/:class/:attachment/:id_partition/:style/:filename"
path = "/_#{Rails.env}#{path}" unless Rails.env.production?
Paperclip::Attachment.default_options[:path] = path

# Set the bucket region.
Paperclip::Attachment.default_options[:s3_region] = ENV["S3_REGION"]

# Create HTTPS links.
Paperclip::Attachment.default_options[:s3_protocol] = "https"
