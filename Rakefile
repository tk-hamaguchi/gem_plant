require "bundler/gem_tasks"

Dir.glob(File.expand_path('../lib/tasks/*.rake', __FILE__)).each { |f| load f }

task :default => [ :spec, :features, :yard ]
