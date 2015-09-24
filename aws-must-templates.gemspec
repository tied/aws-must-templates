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
  Set of extensible templates for [aws-must](https://github.com/jarjuk/aws-must) tool to generate
  CloudFormation JSON from a YAML configuration, and a
  Test Runner for validating correctness of CloudFormation stacks provisioned.
EOF
  s.authors         = ["jarjuk"]
  s.files           = ["README.md", "smoke.yaml"] | Dir.glob( "suite*.yaml")  | Dir.glob("mustache/**/*")  | Dir.glob("lib/**/*")  | Dir.glob("pics/*.jpg") | Dir.glob("spec/**/*") 
  # s.require_paths   = [ "lib" ]
  s.license       = 'MIT'

  s.add_runtime_dependency 'aws-must',         '~> 0.0', '>=0.0.14'


  s.homepage              = "https://github.com/jarjuk/aws-must-templates"

  s.required_ruby_version = '~> 2'

  # Test Runner
  s.add_runtime_dependency 'rake', '~>10.4'
  s.add_runtime_dependency 'rspec', '~>3.3'
  s.add_runtime_dependency 'serverspec',  '~> 2.21'
  s.add_runtime_dependency 'aws-ssh-resolver', '~>0.0', '>=0.0.3'


end
