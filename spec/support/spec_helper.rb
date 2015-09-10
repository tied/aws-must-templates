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

# EC2 intstance with Name tag
describe_named_instances = 
  "aws ec2 describe-instances --filters 'Name=tag-key,Values=Name'"

# # EC2 with a given name
# # `describe ec2 describe-instance --filters "Name=tag:Name,Values=#{instance_id}"
# describe_ec2_instance_cmd =
#   "aws  ec2 describe-instances --filters 'Name=tag:Name,Values=#{instance_id}'"


# SSH client configuration must be in CWD (=user directory)
ssh_config_file = "ssh/config.aws"
                                          # file to use
# stack states

SUCESS_STATES  = ["CREATE_COMPLETE", "UPDATE_COMPLETE"]
FAILURE_STATES = ["CREATE_FAILED", "DELETE_FAILED", "UPDATE_ROLLBACK_FAILED", "ROLLBACK_FAILED", "ROLLBACK_COMPLETE","ROLLBACK_FAILED","UPDATE_ROLLBACK_COMPLETE","UPDATE_ROLLBACK_FAILED"]
END_STATES     = SUCESS_STATES + FAILURE_STATES

# ------------------------------------------------------------------
# Return instance from named_'ec2_instances' with tag
# Name='instance_id', nil otherwise

def find_named_ec2_instance( named_ec2_instances, instance_id )
  instances =  named_ec2_instances["Reservations"].map { |rsv|  rsv['Instances'].first }
  # puts "instances=#{instances}"
  instance = instances.select{ |i| i['Tags'].select{ |t| t['Key'] == "Name" && t['Value']==instance_id }.any?}.first
  return instance
end

# return array of instances with pubcli dns
def find_instances_with_public_dnsname( named_ec2_instances )
  instances =  named_ec2_instances["Reservations"].map { |rsv|  rsv['Instances'].first }
  return instances.select{ |i| !i['PublicDnsName'].nil? && !i['PublicDnsName'].empty? }
end

# ------------------------------------------------------------------
# return hostname from first match
#
# * try to locate 'instance_id' in 'named_ec2_instances'
#    * Use PublicDnsName if defined
#    * Use PrivatecDnsName
# * instance_id


def find_hostname( instance_id, stack_json, named_ec2_instances )

  # described_instances = JSON.parse( %x{ #{describe_ec2_instance_cmd} } )
  ec2_instance = find_named_ec2_instance( named_ec2_instances, instance_id )

  if ec2_instance then 
    return ec2_instance['PublicDnsName'] unless (ec2_instance['PublicDnsName'].nil? || ec2_instance['PublicDnsName'].empty?)
    return ec2_instance['PrivateDnsName'] unless (ec2_instance['PrivateDnsName'].nil? || ec2_instance['PrivateDnsName'].empty?)
  end

  # * instance_id
  return instance_id

end

# return ssh options for 'hostname_for_instance'
def read_ssh_options( hostname_for_instance, ssh_config_file, named_ec2_instances )


  instances_with_public_dnsname = find_instances_with_public_dnsname( named_ec2_instances )

  # puts "instances_with_public_dnsname=#{instances_with_public_dnsname}"
  ssh_config_file_tmp = "#{ssh_config_file}.tmp"

  File.open( ssh_config_file_tmp, 'w' ) do |f|

    # First part defines 'HostName' = PublicDnsName for each 'instance_id'
    f.write( "# instances which have 'PublicDnsName' value and have 'Name' tag\n\n")


    instances_with_public_dnsname.each do |i|

      instance_id = i['Tags'].select{ |t| t['Key'] == 'Name'}.first['Value']
      public_dnsname  = i['PublicDnsName']
      f.write( "host #{instance_id}\n")
      f.write( "    HostName #{public_dnsname}\n\n")
    end # instances
    f.write( "\n\n\n" )

    # append manually managed ssh-config
    f.write( "# file #{ssh_config_file} appended\n")

    File.open( ssh_config_file, "r" ).each do |line|
      
      f.write( line )

    end # appedn lines in ssh_config

  end # file wrei

  # use temp file here, which has HostNames populated with aws PublicDnsNames
  options = Net::SSH::Config.for( hostname_for_instance, [ ssh_config_file_tmp ] )

  options[:host_name] = hostname_for_instance

  options[:user] ||= Etc.getlogin

  # OpenSSH logger
  options[:verbose] = :info # :debug, :info, :warn, :error, :fatal

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
instance_id         = ENV['TARGET_INSTANCE_ID']  # instance being tested (if any)

# map suite_id to stack_id
stack_id            = test_suites.get_suite_stack_id(  suite_id )

puts "------------------------------------------------------------------"
puts "instance_id #{instance_id}" if instance_id


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
# Read EC2 instances
named_ec2_instances = JSON.parse( %x{ #{describe_named_instances} } )

# ------------------------------------------------------------------

hostname_for_instance = find_hostname( instance_id, stack_json, named_ec2_instances )
puts "Using HostName '#{hostname_for_instance}' for instance_id '#{instance_id}'"

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

# #options = Net::SSH::Config.for( instance_id, [ ssh_config_file ] )
# options = Net::SSH::Config.for( hostname_for_instance, [ ssh_config_file ] )
# puts "instance_id #{instance_id}-->#{hostname_for_instance}--> options=#{options}"

# options[:host_name] = hostname_for_instance

# options[:user] ||= Etc.getlogin
# options[:verbose] = :info # :debug, :info, :warn, :error, :fatal

options = read_ssh_options( hostname_for_instance, ssh_config_file, named_ec2_instances )
puts "instance_id #{instance_id}-->#{hostname_for_instance}--> options=#{options}"

set :host,        options[:host_name]#  || instance_id

set :ssh_options, options

# Disable sudo
# set :disable_sudo, true


# Set environment variables
# set :env, :LANG => 'C', :LC_MESSAGES => 'C' 

# Set PATH
# set :path, '/sbin:/usr/local/sbin:$PATH'


