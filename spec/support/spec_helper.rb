require 'serverspec'
require 'net/ssh'
require 'json'

# serverspec extensions
require_relative "./utils.rb"

# test-suites interface
require_relative "../../lib/test-suites/test_suites.rb"

# load test-suites.yaml
test_suites = AwsMustTemplates::TestSuites::TestSuites.new

# ------------------------------------------------------------------
# sudo password (ask implemented by serverspec init)

set :backend, :ssh

if ENV['ASK_SUDO_PASSWORD']
  begin
    require 'highline/import'
  rescue LoadError
    fail "highline is not available. Try installing it."
  end
  set :sudo_password, ask("Enter sudo password: ") { |q| q.echo = false }
else
  set :sudo_password, ENV['SUDO_PASSWORD']
end

# ------------------------------------------------------------------
# suite.rake sets target ENV for suite and instance id

suite_id            = ENV['TARGET_SUITE_ID']     # test suite being processed
instance_id         = ENV['TARGET_INSTANCE_ID']  # instance being tested (if any)

# map suite_id to stack_id
stack_id            = test_suites.get_suite_stack_id(  suite_id )

puts "------------------------------------------------------------------"
puts "instance_id #{instance_id}" if instance_id

# ------------------------------------------------------------------
# Constants used in stack

output_key_for_hostname  = instance_id    # Stack Output variable for 
                                          # ip/hostname for the instance

describe_stacks_command  = 
  "aws cloudformation describe-stacks"    # read json using aws cli

# SSH client configuration must be in CWD (=user directory)
ssh_config_file = "ssh/config"
                                          # file to use
# stack states

SUCESS_STATES  = ["CREATE_COMPLETE", "UPDATE_COMPLETE"]
FAILURE_STATES = ["CREATE_FAILED", "DELETE_FAILED", "UPDATE_ROLLBACK_FAILED", "ROLLBACK_FAILED", "ROLLBACK_COMPLETE","ROLLBACK_FAILED","UPDATE_ROLLBACK_COMPLETE","UPDATE_ROLLBACK_FAILED"]
END_STATES     = SUCESS_STATES + FAILURE_STATES

# ------------------------------------------------------------------
# access cloudformation stacks using aws cli

all_stacks_json = JSON.parse( %x{ #{describe_stacks_command} } )

# extract json -subdocument for stack of interest
stack_json = all_stacks_json["Stacks"].select{ |a| a["StackName"] == stack_id }.first
raise <<-EOS unless stack_json

    Could locate '#{stack_id}' in JSON

    #{all_stacks_json}


    returned with command '#{describe_stacks_command}'


EOS

raise "Stack '#{stack_id}' status='#{stack_json["StackStatus"]} is not ready (=#{SUCESS_STATES}) '" unless SUCESS_STATES.include?( stack_json["StackStatus"] )

if instance_id then
  # find output parameter defining hostname (or ip address)
  hostname_in_stack=stack_json["Outputs"].select {|a| a["OutputKey"] == output_key_for_hostname }.first["OutputValue"]
  raise "Could not find OutputKey '#{output_key_for_hostname}' in stack '#{stack}' for instance_id '#{instance_id}'" unless hostname_in_stack
end

# create a hash, which is accessible in spec tests are 'property' 
properties = {
  "Outputs" =>  stack_json["Outputs"] ? stack_json["Outputs"].inject( {} ) { |r,e| r[e["OutputKey"]] = e["OutputValue"] ; r  } : {},
  "Parameters" => stack_json["Parameters"] ? stack_json["Parameters"].inject( {} ) { |r,e| r[e["ParameterKey"]] = e["ParameterValue"] ; r  }: {},
   # Roles for test (from instance or from common suites)
  "Roles" => (  instance_id ? test_suites.suite_instance_roles( suite_id,  instance_id ) : test_suites.suite_roles( suite_id ) ),
  :host => instance_id,
  :stack_id => stack_id,
  :suite_id=> suite_id,
}

# puts properties
# make properties context known to serverspec
set_property properties

# ------------------------------------------------------------------
# access ssh-configs

# CloudFormatio instance resources are defined in 'ssh_config_file' 

raise <<-EOS unless File.exist?( ssh_config_file )

   Could not find ssh configuration file in '#{ssh_config_file}'.

   Serverspec uses ssh to connect to #{instance_id}, but no configuration found!

EOS

options = Net::SSH::Config.for(instance_id, [ ssh_config_file ] )
# puts "instance_id #{instance_id}, options=#{options}"

# use ip host_name to access stack resource `instance_id`
options[:host_name] = hostname_in_stack

options[:user] ||= Etc.getlogin

set :host,        options[:host_name] || instance_id
set :ssh_options, options

# Disable sudo
# set :disable_sudo, true


# Set environment variables
# set :env, :LANG => 'C', :LC_MESSAGES => 'C' 

# Set PATH
# set :path, '/sbin:/usr/local/sbin:$PATH'
