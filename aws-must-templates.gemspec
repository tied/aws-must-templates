# -*- encoding: utf-8; mode: ruby -*-

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 

# http://guides.rubygems.org/make-your-own-gem/

Gem::Specification.new do |s|

  # version           = "0.0.1.pre"
  version           = File.open( "VERSION", "r" ) { |f| f.read }.strip.gsub( "-SNAPSHOT", ".pre" )

  s.name            = 'aws-must-templates'
  s.version         = version
  s.date            = Time.now.strftime( "%Y-%m-%d" )  #'2014-09-10'
  s.summary         = "Amazon Cloudformation templates for aws-must'"
  s.description     = <<EOF
aws-must is a tool, which allows separating infrastructure
configuration and Amazon related syntax using YAML and Mustache templates.

This repo contains templates for generating CloudFormation json -templates 
from YAML -configuration.
EOF
  s.authors         = ["jarjuk"]
  s.files           = ["README.md"] | Dir.glob("mustache/**/*") 
  # s.require_paths   = [ "lib" ]
  s.license       = 'MIT'

  s.add_runtime_dependency 'aws-must',          '~>0.0.12'


end
