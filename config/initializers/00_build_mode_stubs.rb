# This initializer runs first (00_ prefix) to stub out database-dependent code during build
# when ASSETS_PRECOMPILE=false is set

if ENV['ASSETS_PRECOMPILE'] == 'false'
  # This runs before Rails initializes
  Rails.application.config.before_initialize do
    puts "Build mode: Preventing database access during initialization"

    # Prevent any AR model from establishing connections
    if defined?(ActiveRecord::Base)
      ActiveRecord::Base.class_eval do
        def self.establish_connection(*args)
          # Do nothing during build
        end

        def self.connected?
          false
        end
      end
    end
  end

  # This runs after Rails loads but before eager loading
  Rails.application.config.after_initialize do
    puts "Build mode: Stubbing Hyrax::FlexibleSchema after initialization"

    # Stub Hyrax::FlexibleSchema to prevent database queries
    if defined?(Hyrax::FlexibleSchema)
      Hyrax::FlexibleSchema.class_eval do
        def self.current_schema_id
          nil
        end

        def self.current_schema
          nil
        end

        def self.find(*args)
          nil
        end

        def self.where(*args)
          []
        end

        def self.all
          []
        end

        def self.table_exists?
          false
        end
      end
    end
  end
end
