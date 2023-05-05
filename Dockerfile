# Use Ruby 3.2.1 as the base image
FROM ruby:3.2.1

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
RUN bundle exec rails assets:precompile

# Expose port 3000 for the Rails server
EXPOSE 3000

# Start the Rails server
CMD bundle exec rails server -b 0.0.0.0

