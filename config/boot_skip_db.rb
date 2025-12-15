# This file is loaded very early in the boot process (before Rails)
# Skip database operations during build phase when ASSETS_PRECOMPILE=false

if ENV['ASSETS_PRECOMPILE'] == 'false'
  puts "=" * 80
  puts "BUILD MODE: Skipping database initialization"
  puts "Assets will be compiled on first container start"
  puts "=" * 80

  # Override ActiveRecord to prevent any database connections
  require 'active_record' rescue nil

  if defined?(ActiveRecord)
    module ActiveRecord
      class Base
        class << self
          def establish_connection(*); end
          def connected?; false; end
          def connection; raise "Database disabled during build"; end
        end
      end

      module ConnectionHandling
        def establish_connection(*); end
      end

      # Prevent migrations from running
      class MigrationContext
        def initialize(*); end
        def migrations; []; end
        def current_version; 0; end
      end
    end
  end

  # Stub out Hyrax::FlexibleSchema which tries to query during initialization
  # This needs to happen before Rails loads Hyrax
  module HyraxBuildStubs
    def self.stub_flexible_schema!
      return unless defined?(Hyrax)

      module Hyrax
        class FlexibleSchema
          def self.current_schema_id; nil; end
          def self.current_schema; nil; end
          def self.find(*); nil; end
          def self.all; []; end
        end
      end
    end
  end
end
