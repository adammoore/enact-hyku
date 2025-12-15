# Prevent database access during asset precompilation
# This is necessary because Hyrax's flexible schema tries to query the database
# during initialization, but the database isn't available during Docker build

if defined?(Rake) && Rake.application.top_level_tasks.any? { |t| t.include?('assets') }
  # Disable eager loading during asset precompilation
  Rails.application.config.eager_load = false

  # Prevent database connections
  Rails.application.config.active_record.dump_schema_after_migration = false

  # Skip callbacks that might access the database
  ActiveSupport.on_load(:active_record) do
    # Stub the problematic Hyrax schema loader
    module Hyrax
      class FlexibleSchema
        def self.current_schema_id
          nil
        end
      end
    end
  end
end
