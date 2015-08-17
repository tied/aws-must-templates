require 'serverspec'
require 'net/ssh'

# Added
require 'json'


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

host                = ENV['TARGET_HOST']    # Host to test
stack               = ENV['TARGET_STACK']   # Stack context for the host

puts "------------------------------------------------------------------"
puts "host #{host}"

# ------------------------------------------------------------------
# Constants used in stack


output_key_for_hostname  = host           # Output variable with
                                          # keyvalue 'host' holds the
                                          # IP or hostname for the
                                          # 'host'

describe_stacks_command  = 
  "aws cloudformation describe-stacks"    # read json using aws cli

ssh_config_file = 
  File.join( 
            File.dirname(__FILE__), 
            "../ssh/config" )             # SSH client configuration
                                          # file to use


# ------------------------------------------------------------------
# access cloudformation stacks using aws cli

stack_json = JSON.parse( %x{ #{describe_stacks_command} } )

# extract json -subdocument for stack of interest
stack_json = stack_json["Stacks"].select{ |a| a["StackName"] == stack }.first
raise "Could not find stack '#{stack}'" unless stack_json

# find output parameter defining hostname (or ip address)
hostname_in_stack=stack_json["Outputs"].select {|a| a["OutputKey"] == output_key_for_hostname }.first["OutputValue"]
raise "Could not find OutputKey '#{output_key_for_hostname}' in stack '#{stack}' for host '#{host}'" unless hostname_in_stack

# extract Parameters and Output key (string) -value pairs  from cloudformation json 
properties = {
  "Outputs" =>  stack_json["Outputs"].inject( {} ) { |r,e| r[e["OutputKey"]] = e["OutputValue"] ; r  },
  "Parameters" => stack_json["Parameters"].inject( {} ) { |r,e| r[e["ParameterKey"]] = e["ParameterValue"] ; r  },
  :host => host,
  :stack => stack,
}

# puts properties
# make properties context known to serverspec
set_property properties

# ------------------------------------------------------------------
# access ssh-configs

# CloudFormatio instance resources are defined in 'ssh_config_file' 

options = Net::SSH::Config.for(host, [ ssh_config_file ] )
# puts "host #{host}, options=#{options}"

# use ip host_name to access stack resource `host`
options[:host_name] = hostname_in_stack

options[:user] ||= Etc.getlogin

set :host,        options[:host_name] || host
set :ssh_options, options

# Disable sudo
# set :disable_sudo, true


# Set environment variables
# set :env, :LANG => 'C', :LC_MESSAGES => 'C' 

# Set PATH
# set :path, '/sbin:/usr/local/sbin:$PATH'
