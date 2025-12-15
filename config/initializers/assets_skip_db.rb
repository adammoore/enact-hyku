# Prevent database access during build phase
# This is necessary because Hyrax's flexible schema tries to query the database
# during initialization, but the database isn't available during Docker build

# Skip all database operations during build
if ENV['ASSETS_PRECOMPILE'] == 'false'
  Rails.application.config.eager_load = false

  # Prevent ActiveRecord from trying to establish connections
  Rails.application.config.active_record.migration_error = false if Rails.application.config.respond_to?(:active_record)

  puts "Build mode: Skipping database initialization and eager loading"
end
