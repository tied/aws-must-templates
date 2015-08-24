# -*- mode: ruby -*-


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
# configs


aws_must          = "aws-must.rb"         # command to conver yaml-configs to cf-templates
generate_docs_dir = "generated-docs"      # html docmente generated here
cf_templates      = "cf-templates"        # directory where CloudFormation json templates are generated

# ------------------------------------------------------------------
# suite namespace

require_relative  "./lib/tasks/common.rb"
import "./lib/tasks/suite.rake"

# and init it
suite_properties = AwsMustTemplates::Common::init_suites
stacks = AwsMustTemplates::Common::init_stacks( suite_properties )


# ------------------------------------------------------------------
# usage 

desc "list tasks"
task :usage do
  puts "Tasks: #{(Rake::Task.tasks - [Rake::Task[:usage]]).join(', ')}"
  puts "(type rake -T for more detail)\n\n"
end


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
# dev.workflow defined here

namespace "dev" do |ns|

  task "docs-html" do
    file = "#{generate_docs_dir}/aws-must-templates.html"
      capture_stdout_to( file ) { sh "#{aws_must} doc | markdown" }
  end

  # generate an example json
  task "docs-cf", :suite do |t,args|


    args.with_defaults(:stack => "*")
    if args.suite 
      stack = args.suite
      file = "#{generate_docs_dir}/#{stack}.json"
      capture_stdout_to( file ) { sh "#{aws_must} gen #{stack}.yaml | jq ." }
    else
      suite_properties.each do |suite|
        stack = suite.keys.first
        file = "#{generate_docs_dir}/#{stack}.json"
        capture_stdout_to( file ) { sh "#{aws_must} gen #{stack}.yaml | jq ." }
      end
      
    end

  end

  desc "Template html-documentaion, suite json files  into `{generate_docs_dir}` -subdirectory"
  task :docs => ["dev:docs-html", "dev:docs-cf" ]


  desc "Run unit tests"
  task :rspec, :rspec_opts  do |t, args|
    args.with_defaults(:rspec_opts => "")
    sh "bundle exec rspec --format documentation #{args.rspec_opts} spec/mustache"
  end

  desc "Launch guard"
  task :guard do
    sh "bundle exec guard"
  end

  desc "Build gempspec"
  task :build do
    sh "gem build aws-must-templates.gemspec"
  end

  desc "Install locally"
  task :install do
    version = version()
    sh "gem install ./aws-must-templates-#{version}.gem"
  end

  desc "Finalize delivery"
  task "fast-delivery" => [ "dev:docs", "rt:release", "rt:push", "rt:snapshot" ]

  desc "Run all tests suites && create delivery"
  task "full-delivery" => [ "suite:all", "dev:fast-delivery" ]

end 

# ------------------------------------------------------------------
# common methods

# 
def capture_stdout_to( file )
  real_stdout, = $stdout.clone
  $stdout.reopen( file )
  $stdout.sync = true
  yield
  # $stdout.string
ensure
  $stdout.reopen( real_stdout )
  $stdout.sync = true

end


# output stack json to file
def stack_json( stack ) 
end
