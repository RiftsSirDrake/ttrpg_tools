# Use the official Ruby image
FROM ruby:3.0.5

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
    nodejs \
    default-mysql-client \
    build-essential \
    libmariadb-dev

# Set working directory
WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the application
COPY . .

# Add a script to be executed every time the container starts.
COPY bin/docker-entrypoint /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint
ENTRYPOINT ["docker-entrypoint"]

EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
