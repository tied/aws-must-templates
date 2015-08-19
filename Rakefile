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

# ------------------------------------------------------------------
# test suites

import "./lib/tasks/suite.rake"


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

  task "docs-html" do
    file = "#{generate_docs_dir}/aws-must-templates.html"
      capture_stdout_to( file ) { sh "#{aws_must} doc | markdown" }
  end

  # generate an example json
  task "docs-cf" do
    suite = "suite1"
    file = "#{generate_docs_dir}/#{suite}.json"
      capture_stdout_to( file ) { sh "#{aws_must} gen #{suite}.yaml | jq ." }
  end

  desc "Generate html  documentaion into `{generate_docs_dir}` -subdirectory"
  task :docs => ["dev:docs-html", "dev:docs-cf" ]

  desc "Finalize delivery"
  task "fast-delivery" => [ "dev:docs", "rt:release", "rt:push", "rt:snapshot" ]

  desc "Run all tests suites && create delivery"
  task "full-delivery" => [ "suite:all", "dev:fast-delivery" ]

end 

# ------------------------------------------------------------------
# common methods

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
