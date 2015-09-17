require 'serverspec'
require 'net/ssh'
require 'json'

# serverspec extensions
require_relative "./utils.rb"

# test-suites interface
require_relative "../../lib/test-suites/test_suites.rb"


# ------------------------------------------------------------------
# Constants 

describe_stacks_command  = 
  "aws cloudformation describe-stacks"    # read json using aws cli

# SSH client configuration to use
ssh_config_file = "ssh/config.aws"
                                          # file to use
# stack states

SUCESS_STATES  = ["CREATE_COMPLETE", "UPDATE_COMPLETE"]
FAILURE_STATES = ["CREATE_FAILED", "DELETE_FAILED", "UPDATE_ROLLBACK_FAILED", "ROLLBACK_FAILED", "ROLLBACK_COMPLETE","ROLLBACK_FAILED","UPDATE_ROLLBACK_COMPLETE","UPDATE_ROLLBACK_FAILED"]
END_STATES     = SUCESS_STATES + FAILURE_STATES


# return ssh options for 'hostname_for_instance'
def read_ssh_options( instance_name, ssh_config_file, options_init )


  raise <<-EOS unless File.exist?( ssh_config_file )

   Could not find ssh configuration file in '#{ssh_config_file}'.

   Serverspec uses ssh to connect to #{instance_name}, but no configuration found!

  EOS


  # start search for an instance id
  # puts "read_ssh_options: instance_name:#{instance_name}"
  host = instance_name

  options = Net::SSH::Config.for( host, [ ssh_config_file ] )
  # puts "read_ssh_options: host:#{host} --> options#{options}"
  # options[:verbose] = :info # :debug, :info, :warn, :error, :fatal
    
  # mapped to another name?
  if options[:host_name] then
    host = options[:host_name]
    options2 = Net::SSH::Config.for( host, [ ssh_config_file ] )
    # puts "read_ssh_options: host:#{host} --> options2#{options2}"
    if options2[:proxy] then
      # use proxy - if defined
      options = options2 
      # keep original host_name where to connect
      options[:host_name] = host
    end
  end

  # puts "read_ssh_options: result host:#{host} --> options#{options}"
  return options

end

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Main

# ------------------------------------------------------------------
# load test-suites.yaml to an object

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
instance_name       = ENV['TARGET_INSTANCE_NAME']  # instance being tested (if any)

# map suite_id to stack_id
stack_id            = test_suites.get_suite_stack_id(  suite_id )

puts "------------------------------------------------------------------"
puts "instance_name #{instance_name}" if instance_name


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

# ------------------------------------------------------------------
# hash in accessible in spec tests with name 'property' 

properties = {
  "Outputs" =>  stack_json["Outputs"] ? stack_json["Outputs"].inject( {} ) { |r,e| r[e["OutputKey"]] = e["OutputValue"] ; r  } : {},
  "Parameters" => stack_json["Parameters"] ? stack_json["Parameters"].inject( {} ) { |r,e| r[e["ParameterKey"]] = e["ParameterValue"] ; r  }: {},
   # Roles for test (from instance or from common suites)
  "Roles" => (  instance_name ? test_suites.suite_instance_roles( suite_id,  instance_name ) : test_suites.suite_roles( suite_id ) ),
  :host => instance_name,
  :instance_name => instance_name,
  :stack_id => stack_id,
  :suite_id=> suite_id,
}

# puts properties
# make properties context known to serverspec
set_property properties

# ------------------------------------------------------------------
# access ssh-configs

# CloudFormatio instance resources are defined in 'ssh_config_file' 

options = read_ssh_options( instance_name, ssh_config_file, {} )
# puts "instance_name #{instance_name}--> options=#{options}"

set :host,        options[:host_name]#  || instance_name
set :ssh_options, options

set :request_pty, true
# Disable sudo
# set :disable_sudo, true


# Set environment variables
# set :env, :LANG => 'C', :LC_MESSAGES => 'C' 

# Set PATH
# set :path, '/sbin:/usr/local/sbin:$PATH'


