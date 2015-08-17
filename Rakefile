# -*- mode: ruby -*-

# require "stringio"

# Rake.application.options.trace_rules = true

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
require 'rake'
require 'rspec/core/rake_task'

# ------------------------------------------------------------------
# configs


suite_configs = 'test-suites.yaml'    # YAML configuration file for suites/instances
aws_must="aws-must.rb"                # command to conver yaml-configs to cf-templates
cf_templates = "cf-templates"         # directory for CloudFormation json templates

# ------------------------------------------------------------------
# Init

suite_properties = YAML.load_file( suite_configs )
stacks = Rake::FileList.new( suite_properties.map { |s| s.keys.first + '.yaml'} )


# ------------------------------------------------------------------
# rules

# this rule 'source_for_json' to find yaml file to convert to json
rule ".json" => ->(f){ source_for_json(f)} do |t|
  sh "#{aws_must} gen #{t.source} > #{t.name}"
end

# source_for_json is the yaml file in working directory
def source_for_json( json_file )
  json_file.pathmap( "%n.yaml" )
end

# ------------------------------------------------------------------
# namespace

namespace :suite do

  # suite_properties.each{  |a| a.keys.first }

  # **********
  desc "All suites"
  task :all => suite_properties.map{ |s| "suite:" + s.keys.first }

  # **********
  desc "Create CloudFormation json templates into #{cf_templates}"
  task :json => stacks.pathmap( "#{cf_templates}/%X.json" )

  suite_properties.each do |suite_map|

    suite_id = suite_map.keys.first
    suite = suite_map[suite_id]
    
    # use suite_is as stack name
    stack = suite_id

    # **********
    # Run suite suite_id
    desc "Suite #{suite_id} - #{suite['desc']}"
    suite_tasks = 
      [ "suite:#{suite_id}-stack-create" ] +  
      [ "suite:#{suite_id}-common" ] +  
      ( suite["instances"] ? suite["instances"].each.map{ |a| "suite:#{suite_id}:" + a.keys.first } : [] ) + 
      [ "suite:#{suite_id}-stack-delete" ] 

    task suite_id do
      suite_tasks.each do |t|
        begin
          Rake::Task[t].invoke
          # # Run in isolation && continue no matter what
          # sh "rake #{t}; true"
        rescue => e
          puts "#{e.class}: #{e.message}"
          puts "continue with next task"
        end
      end
    end

    # **********
    # Create stack for a suite
    desc "Create stack #{stack} for suite #{suite_id}"
    task "#{suite_id}-stack-create" => [ "#{cf_templates}/#{stack}.json"] do
      sh "aws cloudformation create-stack --stack-name #{stack} --capabilities CAPABILITY_IAM  --template-body \"$(cat #{cf_templates}/#{stack}.json)\"  --disable-rollback"
    end

    # **********
    # delete stack for a suite
    desc "Delete stack #{stack} for suite #{suite_id}"
    task "#{suite_id}-stack-delete" do
      sh "aws cloudformation delete-stack --stack-name #{stack}"
    end

    # **********
    desc "Show status for stack #{stack}"
    task "#{suite_id}-stack-status" do
      sh "aws cloudformation describe-stacks --stack-name #{stack}"
    end

    # **********
    # test common roles for suite
    desc "Suite #{suite_id} - common"
    RSpec::Core::RakeTask.new( "#{suite_id}-common" ) do |t|
      puts "------------------------------------------------------------------"
      puts "suite=#{suite_id }"

      # see spec/spec_helper.rb
      ENV['TARGET_STACK'] = stack

      # test all roles for the instance
      t.rspec_opts = "--format documentation"
      t.pattern = 'spec/{' + suite["roles"].join(',') + '}/*_spec.rb'

    end



    # instance tasks (within suite)
    namespace suite_id do

      suite["instances"].each do |instance_map|

        instance_id = instance_map.keys.first
        instance = instance_map[instance_id]
        # **********
        desc "Suite #{suite_id} - instance #{instance_id}"
        RSpec::Core::RakeTask.new( instance_id ) do |t|

          puts "------------------------------------------------------------------"
          puts "suite=#{suite_id }, instance=#{instance_id}"

          # see spec/spec_helper.rb
          ENV['TARGET_STACK'] = stack
          ENV['TARGET_HOST'] = instance_id

          # test all roles for the instance
          t.rspec_opts = "--format documentation"
          t.pattern = 'spec/{' + instance["roles"].join(',') + '}/*_spec.rb'

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
