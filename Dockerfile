FROM ruby:2.6.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev curl

RUN apt-get update && apt-get install make bash postgresql-client netcat -y

# Install NodeJS 8.x, imagemagick and yarn
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y nodejs imagemagick yarn --no-install-recommends && rm -rf /var/lib/apt/lists/*

# Rails logger output to STDOUT only
ENV RAILS_LOG_TO_STDOUT=1

# set the app directory var
ENV APP_HOME /code
WORKDIR $APP_HOME

# Set Gemfile path
ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile

ENV BUNDLE_PATH /gems
ENV BUNDLE_HOME /gems

# Where Rubygems will look for gems, similar to BUNDLE_ equivalents.
ENV GEM_HOME /gems
ENV GEM_PATH /gems

# Add /gems/bin to the path so any installed gem binaries are runnable from bash.
ENV PATH /gems/bin:$PATH

# Increase how many threads Bundler uses when installing. Optional!
ENV BUNDLE_JOBS 4

# How many times Bundler will retry a gem download. Optional!
ENV BUNDLE_RETRY 3

ENV RAILS_ENV staging

# Install nodejs dependencies
ADD package.json $APP_HOME/
RUN yarn install

# Install ruby dependencies
ADD Gemfile Gemfile.lock $APP_HOME/
RUN bundle install --without development test
ADD . $APP_HOME/

RUN bundle exec rake assets:precompile

CMD bundle exec puma -C config/puma.rb
