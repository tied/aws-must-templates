# -*- mode: ruby -*-


require 'rake'
require 'rspec/core/rake_task'
require 'yaml'

# ------------------------------------------------------------------
# Configs

serverspec_configs = 'serverspec-properties.yaml'

# ------------------------------------------------------------------
# Init

serverspec_properties = YAML.load_file( serverspec_configs )

# ------------------------------------------------------------------
# Global tasks


desc "Run serverspec to all hosts"
task :spec => 'serverspec:all'

# ------------------------------------------------------------------
# Namespace serverspec

namespace :serverspec do

  task :all => serverspec_properties.keys.map {|key| 'serverspec:' + key.split('.')[0] }

  serverspec_properties.keys.each do |key|
    desc "Run serverspec to #{key}"
    RSpec::Core::RakeTask.new(key.split('.')[0].to_sym) do |t|
      ENV['TARGET_HOST'] = key
      t.pattern = 'spec/{' + serverspec_properties[key][:roles].join(',') + '}/*_spec.rb'
    end
  end
end

