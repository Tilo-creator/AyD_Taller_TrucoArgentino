# config/puma.rb

# Puma configuration file.

# Set the number of threads per worker (default: 5).
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

# Define the port Puma will listen on.
port ENV.fetch("PORT") { 3000 }

# Specify the environment (development, production, etc.).
environment ENV.fetch("RACK_ENV") { "production" }

# Enable cluster mode with the number of workers (useful for production).
workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# Preload the application for performance.
preload_app!

# Allow Puma to be restarted by `rails restart` (if using Rails).
plugin :tmp_restart
