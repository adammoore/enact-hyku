# This initializer runs first (00_ prefix) to stub out database-dependent code during build
# when ASSETS_PRECOMPILE=false is set

if ENV['ASSETS_PRECOMPILE'] == 'false'
  Rails.application.config.before_initialize do
    puts "Build mode: Stubbing Hyrax::FlexibleSchema before initialization"

    # Stub Hyrax::FlexibleSchema to prevent database queries
    if defined?(Hyrax)
      module Hyrax
        class FlexibleSchema < ApplicationRecord
          self.abstract_class = true

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

    # Prevent any AR model from establishing connections
    ActiveRecord::Base.class_eval do
      def self.establish_connection(*); end
    end if defined?(ActiveRecord::Base)
  end
end
