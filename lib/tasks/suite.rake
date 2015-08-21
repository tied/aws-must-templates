# -*- mode: ruby -*-

# ------------------------------------------------------------------
# requires

require 'yaml'
require 'json'
require 'rake'
require 'rspec/core/rake_task'


# ------------------------------------------------------------------
# configs

aws_must          = "aws-must.rb"         # command to conver yaml-configs to cf-templates
suite_configs     = 'test-suites.yaml'    # YAML configuration file for suites/instances            
cf_templates      = "cf-templates"        # directory where CloudFormation json templates are generated

# read json using aws cli
describe_stacks_command  =  "aws cloudformation describe-stacks"    

# stack states
SUCESS_STATES  = ["CREATE_COMPLETE", "UPDATE_COMPLETE"]
FAILURE_STATES = ["CREATE_FAILED", "DELETE_FAILED", "UPDATE_ROLLBACK_FAILED", "ROLLBACK_FAILED", "ROLLBACK_COMPLETE","ROLLBACK_FAILED","UPDATE_ROLLBACK_COMPLETE","UPDATE_ROLLBACK_FAILED"]
END_STATES     = SUCESS_STATES + FAILURE_STATES



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
# namespace :suite

namespace :suite do

  # suite_properties.each{  |a| a.keys.first }

  # **********
  desc "All suites"
  all_suites = ["suite:json-clean"] +  suite_properties.map{ |s| "suite:" + s.keys.first }
  task :all do 

    failed_suites = []

    all_suites.each do |t|
      begin
        Rake::Task[t].invoke
        failed_suites << t unless $?.success?
        # # Run in isolation && continue no matter what
        # sh "rake #{t}; true"
      rescue => e
        puts "#{e.class}: #{e.message}"
        failed_suites << t
        # puts e.backtrace
        puts "continue with next suite"
      end

    end # all_suites.each

    if failed_suites.any?  then
      puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      puts "Failed suites"
      puts failed_suites
      puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      raise "failed_suites=#{failed_suites}"
    end

  end # task :all

  # **********
  desc "Clean generated json templates"
  task "json-clean", :stack do |t,args|
    args.with_defaults(:stack => "*")
    sh "rm -f #{cf_templates}/#{args.stack}.json"; 
  end

  # **********
  desc "Create CloudFormation json templates into #{cf_templates}"
  task :json => stacks.pathmap( "#{cf_templates}/%X.json" )

  suite_properties.each do |suite_map|

    suite_id = suite_map.keys.first
    suite = suite_map[suite_id]
    
    # use suite_is as stack name
    stack = suite_id

    # **********
    # Create stack for a suite
    desc "Create stack #{stack} for suite #{suite_id}"
    task "#{suite_id}-stack-create" => [ "#{cf_templates}/#{stack}.json"] do
      sh "aws cloudformation create-stack --stack-name #{stack} --capabilities CAPABILITY_IAM  --template-body \"$(cat #{cf_templates}/#{stack}.json)\"  --disable-rollback"
    end

    desc "Create stack #{stack} for suite #{suite_id}"
    task "#{suite_id}-stack-wait" do

      while true

        stack_json = JSON.parse( %x{ #{describe_stacks_command} } )
        stack_json = stack_json["Stacks"].select{ |a| a["StackName"] == stack }.first
        raise "Could not find stack '#{stack}'" unless stack_json

        break if END_STATES.include?( stack_json["StackStatus"] ) 

        print "."
        $stdout.flush

        sleep 10

      end

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
    # Test common roles for suite
    desc "Suite #{suite_id} - common roles"
    RSpec::Core::RakeTask.new( "#{suite_id}-common" ) do |t|
      puts "------------------------------------------------------------------"
      puts "suite=#{suite_id }"

      # see spec/spec_helper.rb
      ENV['TARGET_STACK'] = stack

      # test all roles for the instance
      t.rspec_opts = "--format documentation"
      t.fail_on_error = false       
      t.pattern = 'spec/{' + suite["roles"].join(',') + '}/*_spec.rb' 

    end if suite.has_key?( "roles" )


    # **********
    # Run tasks for suite suite_id

    desc "Run all takss for suite '#{suite_id}' - #{suite['desc']}"
    suite_tasks = 
      [ 
       "suite:#{suite_id}-stack-create",
        "suite:#{suite_id}-stack-wait", 
      ] + 
      ( Rake::Task.task_defined?(  "suite:#{suite_id}-common"  ) ? [  "suite:#{suite_id}-common"  ] : [] )  + 
      ( suite["instances"] ? suite["instances"].each.map{ |a| "suite:#{suite_id}:" + a.keys.first } : []  ) + 
      [ "suite:#{suite_id}-stack-delete" ] 

    task suite_id do

      failed_tasks = []

      suite_tasks.each do |t|
        begin
          Rake::Task[t].invoke
          failed_tasks << t unless $?.success?
          # # Run in isolation && continue no matter what
          # sh "rake #{t}; true"
        rescue => e
          puts "#{e.class}: #{e.message}"
          failed_tasks << t
          # puts e.backtrace
          puts "continue with next task"
        end
      end

      if ! failed_tasks.empty? then
        puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        puts "Failed tasks"
        puts failed_tasks 
        puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        raise "failed_tasks = #{failed_tasks}"
      end 
        
    end


    # instance tasks (within suite)
    namespace suite_id do

      suite["instances"].each do |instance_map|

        instance_id = instance_map.keys.first
        instance = instance_map[instance_id]

        # **********
        desc "Test roles for instance '#{instance_id}' in suite '#{suite_id}'"
        RSpec::Core::RakeTask.new( instance_id ) do |t|

          puts "------------------------------------------------------------------"
          puts "suite=#{suite_id }, instance=#{instance_id}"

          # see spec/spec_helper.rb
          ENV['TARGET_STACK'] = stack
          ENV['TARGET_HOST'] = instance_id

          # test all roles for the instance
          t.rspec_opts = "--format documentation"
          t.fail_on_error = false       
          t.pattern = 'spec/{' + instance["roles"].join(',') + '}/*_spec.rb'

        end
      end if suite.has_key?("instances")
    end # ns suite_id

  end # suite_properties.each
  
end # ns suite

