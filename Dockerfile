# Use Ruby 3.2.1 as the base image
FROM ruby:3.2.1

# Install dependencies
RUN apt-get update -qq && apt-get install -y curl gnupg2 build-essential libpq-dev

# Install Node.js (LTS version)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y nodejs

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

# Install Redis
RUN apt-get install -y redis-server


RUN mkdir /myapp
# Set the working directory to /app
WORKDIR /app

# Copy the Gemfile and Gemfile.lock into the image
COPY Gemfile Gemfile.lock ./

# Install dependencies
RUN bundle install

# Set the environment variables
ENV RAILS_ENV=production \
    RACK_ENV=production \
        REDIS_URL=redis://redis:6379/0

# Copy the rest of the application code into the image
COPY . .

# Precompile assets
RUN RAILS_ENV=production bundle exec rails assets:precompile

# Expose port 3000 for the Rails server
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the Rails server
CMD bundle exec rails server -b 0.0.0.0

