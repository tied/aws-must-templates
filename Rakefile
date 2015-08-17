# -*- mode: ruby -*-

# require "stringio"

# ------------------------------------------------------------------
# default


task :default => [:usage]

# ------------------------------------------------------------------
# configs

gem = "aws-must-templates"


# ------------------------------------------------------------------
# Internal development

begin

  require "raketools_site.rb"
  require "raketools_release.rb"
rescue LoadError
  # puts ">>>>> Raketools not loaded, omitting tasks"
end


def version() 
  # gemspec wants to use 'pre' and not '-SNAPSHOT'
  return File.open( "VERSION", "r" ) { |f| f.read }.strip.gsub( "-SNAPSHOT", ".pre" )   # version number from file
end

# ------------------------------------------------------------------
# test suites && serverspec 
require 'yaml'

suite_configs = 'test-suites.yaml'

# ------------------------------------------------------------------
# Init

suite_properties = YAML.load_file( suite_configs )

# ------------------------------------------------------------------
# Namespace test:suite:

require 'rspec/core/rake_task'

namespace :suite do

  # suite_properties.each{  |a| a.keys.first }

  desc "All suites"
  task :all => suite_properties.select{  |a| a[a.keys.first].has_key?( "instances" ) }.map{ |a| "suite:" + a.keys.first }

  # task :all => ["suite:smoke"]
  suite_properties.each do |suite_map|
    suite_id = suite_map.keys.first
    suite = suite_map[suite_id]

    # define suite tasks
    desc "Suite #{suite_id} - #{suite['desc']}"
    task suite_id do

      # exec all instances under suite
      suite["instances"].each do |instance_map|
        instance_id = instance_map.keys.first
        instance = suite[instance_id]
        Rake::Task["suite:#{suite_id}:#{instance_id}"].execute
      end

    end



    # define instance tasks under suite namespace
    namespace suite_id do

      suite["instances"].each do |instance_map|

        instance_id = instance_map.keys.first
        instance = instance_map[instance_id]


        desc "Suite #{suite_id} - instance #{instance_id}"
        RSpec::Core::RakeTask.new( instance_id ) do |t|

          puts "------------------------------------------------------------------"
          puts "suite=#{suite_id }, instance=#{instance_id}"


          ENV['TARGET_HOST'] = instance_id
          pattern = 'spec/{' + instance["roles"].join(',') + '}/*_spec.rb'
          # puts "pattern=#{pattern}"
          t.pattern = pattern
        end
      end if suite.has_key?("instances")
    end # ns suite_id

  end # suite_properties.each
  
end # ns suite


import "./lib/tasks/serverspec.rake"


# ------------------------------------------------------------------
# usage 

desc "list tasks"
task :usage do
  puts "Tasks: #{(Rake::Task.tasks - [Rake::Task[:usage]]).join(', ')}"
  puts "(type rake -T for more detail)\n\n"
end

# ------------------------------------------------------------------
# dev.workflow defined here


namespace "dev" do |ns|

  desc "Build gempspec"
  task :build do
    sh "gem build #{gem}.gemspec"
  end

  desc "To run when everything is in version control ok"
  task "full-delivery" => [ "rt:release", "rt:push", "rt:snapshot" ]

end 
