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
  
  namespace "docs" do |ns|

    # tests
    desc "Markdown documention for tests in 'test-suites.yaml'"
    task :tests, :stdout  do |t,args|

      file = "#{generate_docs_dir}/test-suites.md" unless ( args.stdout )

      capture_stdout_to( file ) { 

        puts "# [aws-must-templates](https://github.com/jarjuk/aws-must-templates) - tests"
        

        test_suites.suite_ids.each do |suite_id|
          
          suite = test_suites.get_suite( suite_id )

          puts "## #{suite_id} - #{suite['desc']}"
          puts ""
          puts suite['long_desc']
          puts ""
          puts ""

          puts "### Stack Parameters and Outputs"
          
          puts ""
          puts "<pre>"
          sh "cat #{suite_test_report_filepath( suite_id )}"
          puts "</pre>"

          puts ""
          puts ""

          puts "### Instance Test Reports"
          puts ""

          # iterate suite instancess to create a link to test report
          test_suites.suite_instance_ids( suite_id ).each do |instance_id|
            puts "* [#{instance_id}](#{suite_test_report_filepath(suite_id,instance_id)})"
          end
          

        end # each suite_ids
      } # capture stdout


    end
    
    # path to file where suite_id common output
    def suite_test_report_filepath( suite_id, instance_id=nil )
      "generated-docs/suites/#{suite_id}#{ instance_id ? '-' + instance_id : ""}.txt"
    end

    # mustache templates --> html documentation
    desc "HTMl documention for mustache templates"
    task "mustache" do
      file = "#{generate_docs_dir}/aws-must-templates.html"
      capture_stdout_to( file ) { sh "#{aws_must} doc | markdown" }
    end

    # stack YAML --> CloudFormation Json
    desc "CloudFormation JSON templates for tests in 'test-suites.yaml'"    
    task "cf", :stack do |t,args|

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

    end # task cf

  end # ns docs

  desc "Generate html-, stack CloudFormation JSON templates into `{generate_docs_dir}` -subdirectory"
  task :docs => ["dev:docs:mustache", "dev:docs:cf", "dev:docs:tests" ]

  # ------------------------------------------------------------------
  # unit tests

  namespace :rspec do |ns|

    task :mustache, :rspec_opts  do |t, args|
      args.with_defaults(:rspec_opts => "")
      sh "bundle exec rspec --format documentation spec/mustache"
    end

    task :lib, :rspec_opts  do |t, args|
      args.with_defaults(:rspec_opts => "")
      sh "bundle exec rspec --format documentation spec/lib"
    end
  end # ns 

  desc "Run unit tests"  
  task :rspec => ["dev:rspec:mustache", "dev:rspec:lib" ]

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

# if file defined, redirect stdout (temporaliy) to file 
def capture_stdout_to( file )
  if  file  then
    real_stdout, = $stdout.clone
    $stdout.reopen( file )
    $stdout.sync = true
  end
  yield
  # $stdout.string
ensure
  if file 
    $stdout.reopen( real_stdout )
    $stdout.sync = true
  end
end

