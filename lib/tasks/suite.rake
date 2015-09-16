# -*- mode: ruby -*-

# ------------------------------------------------------------------
# requires

require 'yaml'
require 'json'
require 'rake'
require 'rspec/core/rake_task'

# ------------------------------------------------------------------
# configuration extesions (see task 'suite-runner-configs' for documentation)

default_suite_runner_configs = {
  'ssh_config_file' => "ssh/config.aws",
  'ssh_config_init' => "ssh/config.init",
  'aws_region'      => nil,
}

suite_runner_configs = 
  default_suite_runner_configs.merge( $suite_runner_configs ? $suite_runner_configs : {} )

# ------------------------------------------------------------------
# test-suites.yaml

require_relative  "../test-suites/test_suites.rb"
test_suites = AwsMustTemplates::TestSuites::TestSuites.new

# ------------------------------------------------------------------
# configs

aws_must          = "aws-must.rb"         # command to conver yaml-configs to cf-templates

# read json using aws cli
describe_stacks_command  =  "aws cloudformation describe-stacks"    

# stack states
SUCESS_STATES  = ["CREATE_COMPLETE", "UPDATE_COMPLETE"]
FAILURE_STATES = ["CREATE_FAILED", "DELETE_FAILED", "UPDATE_ROLLBACK_FAILED", "ROLLBACK_FAILED", "ROLLBACK_COMPLETE","ROLLBACK_FAILED","UPDATE_ROLLBACK_COMPLETE","UPDATE_ROLLBACK_FAILED"]
END_STATES     = SUCESS_STATES + FAILURE_STATES


# ------------------------------------------------------------------
# namespace :suite

namespace :suite do

  # **********
  # desc "Outpu configuration"
  task "suite-runner-configs" do

    # puts( default_suite_runner_configs.to_yaml)
    doc = <<EOS
---
# Test Runner suite-runner-default
#  ------------------------------------------------------------------
# 
# copy this file to cwd with the name 'suite-runner-configs.yaml' and
# add following lines to Rakefile
#
#    suite_runner_configs= "suite-runner-configs.yaml"
#    $suite_runner_configs = File.exist?(suite_runner_configs) ? YAML.load_file( suite_runner_configs ) : {}
#
#    spec = Gem::Specification.find_by_name 'aws-must-templates'
#    load "\#{spec.gem_dir}/lib/tasks/suite.rake"
#
#  ------------------------------------------------------------------

# SSH Client Configuration file where EC2 Instance Tag Name/DNS Name
# mapping is synchronized
ssh_config_file: #{default_suite_runner_configs['ssh_config_file']}

# Name of file, which is used to seed 'ssh_config_file', if
# 'ssh_config_file' file does not exist
ssh_config_init: #{default_suite_runner_configs['ssh_config_init']}

# http://docs.aws.amazon.com/sdkforruby/api/index.html#Configuration
# "The SDK searches the following locations for a region: ENV['AWS_REGION']"
# 
# Test runner sets ENV['AWS_REGION'] if following property is set
#
aws_region: #{default_suite_runner_configs['aws_region']}
EOS
    puts doc
  end

  # suite_properties.each{  |a| a.keys.first }

  # **********
  desc "Run all suites"
  task :all, :gen_opts   do |t,args|
    Rake::Task['suite:clean'].invoke()
    Rake::Task['suite:suites'].invoke(args.gen_opts)
  end

  task  :clean do 

    files =   FileList[ "#{suite_test_report_dirpath()}/**/*"]
    files.exclude { |f|  File.directory?(f) }

    rm_rf files unless files.empty?

  end

  # **********
  desc "Syncrronize ec2 instance metadata to "
  task "ec2-sync" do
    aws_ssh_resolver="aws-ssh-resolver.rb"
    sh "#{aws_ssh_resolver} aws --ssh-config-file #{suite_runner_configs['ssh_config_file']} --ssh-config-init #{suite_runner_configs['ssh_config_init']}"
  end


  # **********
  all_suites = test_suites.suite_ids.map{ |id| "suite:" + id }
  task :suites, :gen_opts  do |t,args|

    failed_suites = []

    all_suites.each do |t|
      begin
        Rake::Task[t].invoke( args.gen_opts ) 
        failed_suites << t unless  ( $?.nil? || $?.success? )
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
  test_suites.suite_ids.each do |suite_id|


    # suite = test_suites.get_suite( suite_id )
    
    # find the stack name for suite
    stack = test_suites.get_suite_stack_id( suite_id )

    desc "#{suite_id} - syncrhornize #{suite_runner_configs['ssh_config_file']}"
    task "#{suite_id}-sync", :gen_opts  do |t,args|
      ssh_client_config_synchronize( suite_runner_configs )
    end

    # json
    task "#{suite_id}-json", :gen_opts  do |t,args|
      args.with_defaults( :gen_opts => "-m aws-must-templates" )
      json_template="#{aws_must} gen #{stack}.yaml #{args.gen_opts}"  
      sh "#{json_template}"
    end


    # **********
    # Create stack for a suite
    desc "#{suite_id} - create stack '#{stack}'"
    task "#{suite_id}-stack-create", :gen_opts  do |t,args|
      args.with_defaults( :gen_opts => "-m aws-must-templates" )
      json_template="#{aws_must} gen #{stack}.yaml #{args.gen_opts}"  
      sh "aws cloudformation create-stack --stack-name #{stack} --capabilities CAPABILITY_IAM  --template-body \"$(#{json_template})\"  --disable-rollback"
    end

    desc "#{suite_id} - wait stack #{stack} #{END_STATES.join(', ')} "
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
    desc "#{suite_id} - delete stack #{stack}"
    task "#{suite_id}-stack-delete" do
      sh "aws cloudformation delete-stack --stack-name #{stack}"
    end

    task :report_dir  do 
      report_dir  = suite_test_report_dirpath()
      sh "mkdir -p #{report_dir}" unless File.exist?(report_dir) 
    end

    # **********
    desc "#{suite_id} - show status for stack #{stack}"
    task "#{suite_id}-stack-status" do
      sh "aws cloudformation describe-stacks --stack-name #{stack}"
    end

    # **********
    # Test common roles for suite
    desc "#{suite_id} - common roles"
    RSpec::Core::RakeTask.new( "#{suite_id}-common" ) do |t|

      set_rspec_task( t, suite_runner_configs, test_suites, suite_id )

      # puts "------------------------------------------------------------------"
      # puts "suite=#{suite_id }"

      # # see spec/spec_helper.rb
      # ENV['TARGET_SUITE_ID'] = suite_id

      # test all roles for the instance
      # t.rspec_opts = rspec_opts( suite_id )
      # t.fail_on_error = false       
      # t.ruby_opts= rspec_ruby_opts
      # t.pattern = suite["roles"].map {  |r|  spec_pattern( r ) }.join(",")
      t.pattern = test_suites.suite_role_ids( suite_id ).map{ |r| spec_pattern( r ) }.join(",")


    end if test_suites.suite_roles( suite_id )


    # **********
    # Run tasks for 'suite_id'

    desc "#{suite_id} - #{test_suites.get_suite(suite_id)['desc']}"
    suite_tasks = 
      [ 
       "suite:report_dir", 
       [ "suite:#{suite_id}-stack-create", "gen_opts" ],
       "suite:#{suite_id}-stack-wait", 
       "suite:#{suite_id}-sync", 
      ] + 
      ( Rake::Task.task_defined?(  "suite:#{suite_id}-common"  ) ? [  "suite:#{suite_id}-common"  ] : [] )  + 
      ( test_suites.suite_instance_ids( suite_id ).each.map{ |instance_id| "suite:#{suite_id}:" + instance_id }  ) + 
      [ "suite:#{suite_id}-stack-delete" ] 

    task suite_id, :gen_opts do |ta,args|

      failed_tasks = []

      suite_tasks.each do |task|
        begin
          if task.kind_of?( Array )
            taskname = task.shift
            Rake::Task[taskname].invoke( *(task.select{ |arg_name| args[arg_name]}.map{ |arg_name| args[arg_name] }) )
          else
            taskname = task
            Rake::Task[task].invoke( args )
          end
          failed_tasks << task unless ( $?.nil? || $?.success? )
          # # Run in isolation && continue no matter what
          # sh "rake #{t}; true"
        rescue => e
          puts "#{e.class}: #{e.message}"
          failed_tasks << taskname
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

      # suite["instances"].each do |instance_map|
      test_suites.suite_instance_ids( suite_id ).each do |instance_id|

        # instance_id = instance_map.keys.first
        # instance = instance_map[instance_id]

        # **********
        desc "#{suite_id} - test instance '#{instance_id}'"
        RSpec::Core::RakeTask.new( instance_id ) do |t|

          set_rspec_task( t, suite_runner_configs, test_suites, suite_id, instance_id )

        end
      end # instance_ids
    end # ns suite_id

  end # suite_properties.each

  # ------------------------------------------------------------------
  # DRY methods

  # spec found in 'user_test' or 'gem_test' directory
  def spec_pattern( role ) 
    spec_root="spec/aws-must-templates"
    user_test = File.expand_path( "#{spec_root}/#{role}" )
    gem_test  = File.expand_path(  File.join( File.dirname( __FILE__), "../..", "#{spec_root}/#{role}"  ))
      
    return "#{user_test}/*_spec.rb"  if File.exist?( user_test )
    return "#{gem_test}/*_spec.rb"   if File.exist?( gem_test )

    message =  <<-EOS

       Could not locate test spec 
       in test directory '#{user_test}'
    EOS
    message += <<-EOS if user_test != gem_test
       nor in gem test directory '#{gem_test}'
    EOS
    raise message

  end

  # use -I option to allow Gem and client specs to include spec_helper
  def rspec_ruby_opts
    "-I #{File.join( File.dirname(__FILE__), '../../spec/support' )}"
  end

  # to pass to rpsec
  def rspec_opts( suite_id, instance_id=nil )
    # "--format documentation"
    # "--format progress --format documentation --out generated-docs/suites/#{suite_id}#{ instance_id ? '-'+instance_id : ""}.txt"
    "--format progress --format documentation --out #{suite_test_report_filepath( suite_id, instance_id )}"
  end

  def suite_test_report_filepath( suite_id, instance_id=nil )
    "#{suite_test_report_dirpath()}/#{suite_id}#{ instance_id ? '-' + instance_id : ""}.txt"
  end

  def suite_test_report_dirpath
    "generated-docs/suites"
  end

  # read ec2 instance metadata && update 'ssh_config_file'
  def ssh_client_config_synchronize( suite_runner_configs )
    aws_ssh_resolver="aws-ssh-resolver.rb"
    sh "#{aws_ssh_resolver} aws --ssh-config-file #{suite_runner_configs['ssh_config_file']} --ssh-config-init #{suite_runner_configs['ssh_config_init']}"
  end

  def set_rspec_task( t, suite_runner_configs, test_suites, suite_id, instance_id=nil  )

    puts "------------------------------------------------------------------"
    puts "suite=#{suite_id } #{instance_id ? ' instance:  ' + instance_id : ''}"

    # see spec/spec_helper.rb
    ENV['TARGET_SUITE_ID'] = suite_id
    ENV['TARGET_INSTANCE_ID'] = instance_id if instance_id
    ENV['AWS_REGION'] = suite_runner_configs["aws_region"] if suite_runner_configs["aws_region"]

    t.rspec_opts = rspec_opts( suite_id, instance_id )
    t.fail_on_error = false
    t.ruby_opts= rspec_ruby_opts

    # test all roles for the instance
    pattern = (instance_id ? 
               test_suites.suite_instance_role_ids( suite_id, instance_id ).map{ |r| spec_pattern( r ) }.join(",") :
               test_suites.suite_role_ids( suite_id ).map{ |r| spec_pattern( r ) }.join(",") )

    raise <<-EOS if pattern.nil? ||  pattern.empty?

              No tests defined for an instance in suite=#{suite_id } #{instance_id ? ' for instance ' + instance_id : ''}

          EOS
    t.pattern = pattern

  end

  
end # ns suite

