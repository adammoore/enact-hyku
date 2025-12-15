# Override assets:precompile to skip during build when DB isn't available
# The buildpack will call this, but we skip it and compile assets on first boot

if ENV['ASSETS_PRECOMPILE'] == 'false'
  namespace :assets do
    task :precompile do
      puts "Skipping asset precompilation (ASSETS_PRECOMPILE=false)"
      puts "Assets will be compiled on first container boot"
    end

    task :clean do
      puts "Skipping asset cleaning (ASSETS_PRECOMPILE=false)"
    end
  end
end
