# frozen_string_literal: true
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

# Skip database operations during build phase
require_relative 'boot_skip_db'
