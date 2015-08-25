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
# test-suites.yaml

require_relative  "./lib/test-suites/test_suites.rb"
test_suites = AwsMustTemplates::TestSuites::TestSuites.new

# ------------------------------------------------------------------
# suite namespace

import "./lib/tasks/suite.rake"

# suite_properties = AwsMustTemplates::Common::init_suites
# stacks = AwsMustTemplates::Common::init_stacks( suite_properties )


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
  
  # ------------------------------------------------------------------
  # docs

  # mustache templates --> html documentation
  task "docs-html" do
    file = "#{generate_docs_dir}/aws-must-templates.html"
      capture_stdout_to( file ) { sh "#{aws_must} doc | markdown" }
  end

  # stack YAML --> CloudFormation Json
  task "docs-cf", :stack do |t,args|

    if args.stack 
      stack_id = args.suite
      file = "#{generate_docs_dir}/#{stack_id}.json"
      capture_stdout_to( file ) { sh "#{aws_must} gen #{stack_id}.yaml | jq ." }
    else
      test_suites.stack_ids.each do |stack_id|
        file = "#{generate_docs_dir}/#{stack_id}.json"
        capture_stdout_to( file ) { sh "#{aws_must} gen #{stack_id}.yaml | jq ." }
      end
      
    end

  end

  desc "Generate html-, stack CloudFormation JSON templates into `{generate_docs_dir}` -subdirectory"
  task :docs => ["dev:docs-html", "dev:docs-cf" ]

  # ------------------------------------------------------------------
  # unit tests

  task "rspec-mustache", :rspec_opts  do |t, args|
    args.with_defaults(:rspec_opts => "")
    sh "bundle exec rspec --format documentation spec/mustache"
  end

  task "rspec-lib", :rspec_opts  do |t, args|
    args.with_defaults(:rspec_opts => "")
    sh "bundle exec rspec --format documentation spec/lib"
  end

  desc "Run unit tests"  
  task :rspec => ["dev:rspec-mustache", "dev:rspec-lib" ]

  desc "Launch guard"
  task :guard do
    sh "bundle exec guard"
  end

  # ------------------------------------------------------------------
  # Build && delivery


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

