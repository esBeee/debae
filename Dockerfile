FROM ruby:2.4.1

# Install essentials.
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

# Install imagemagick.
RUN apt-get update -qq && apt-get install -y imagemagick imagemagick-doc

# Install node.
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get update -qq && apt-get install -y nodejs

# Install yarn.
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -qq && apt-get install -y yarn

# Install some gems in individual steps so they can be taken from cache next
# time we rebuild the image.
# NOTE: this only works if the specified versions are matching the version
# specified in the Gemfile.lock.
RUN gem install nokogiri -v '1.8.2'
RUN gem install pg -v '0.21.0'

# Prepare working directory.
RUN mkdir /app
WORKDIR /app

# Install gems specified in Gemfile.
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install

# Add application code.
ADD . /app
