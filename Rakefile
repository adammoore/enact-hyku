# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

# Skip asset precompilation during build if ASSETS_PRECOMPILE=false
# Define stub tasks and exit early to prevent Rails from loading
if ENV['ASSETS_PRECOMPILE'] == 'false'
  namespace :assets do
    task :precompile do
      puts "================================================================================  "
      puts "BUILD MODE: Skipping asset precompilation (ASSETS_PRECOMPILE=false)"
      puts "Assets will be compiled on first container start when database is available"
      puts "================================================================================"
    end
    task :clean do
      puts "Skipping asset cleaning (ASSETS_PRECOMPILE=false)"
    end
  end

  # Define environment task as no-op
  task :environment do
  end

  # Don't load Rails at all
else
  # Normal operation - load Rails
  require File.expand_path('../config/application', __FILE__)

  # Do not use fedora or solr wrappers in docker
  # no reason to run those services locally twice
  if ENV['IN_DOCKER']
    task default: [:rubocop, :spec]
  else
    task default: [:rubocop, :ci]
  end

  Rails.application.load_tasks
end

begin
  require 'solr_wrapper/rake_task'
# rubocop:disable Lint/SuppressedException
rescue LoadError
  # rubocop:enable Lint/SuppressedException
end

task :ci do
  with_server 'test' do
    Rake::Task['spec'].invoke
  end
end
