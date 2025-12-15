# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

# Skip asset precompilation during build if ASSETS_PRECOMPILE=false
# Define stub tasks BEFORE loading Rails to prevent database access
if ENV['ASSETS_PRECOMPILE'] == 'false'
  namespace :assets do
    task :precompile do
      puts "Skipping asset precompilation (ASSETS_PRECOMPILE=false)"
      puts "Assets will be compiled on first container start"
    end
    task :clean do
      puts "Skipping asset cleaning (ASSETS_PRECOMPILE=false)"
    end
  end

  # Also define the environment task to prevent Rails from loading
  task :environment do
    puts "Skipping environment load (ASSETS_PRECOMPILE=false)"
  end
end

require File.expand_path('../config/application', __FILE__)

# Do not use fedora or solr wrappers in docker
# no reason to run those services locally twice
if ENV['IN_DOCKER']
  task default: [:rubocop, :spec]
else
  task default: [:rubocop, :ci]
end

Rails.application.load_tasks

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
