# -*- mode: ruby -*-

# require "stringio"

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
# usage 

desc "list tasks"
task :usage do
  puts "Tasks: #{(Rake::Task.tasks - [Rake::Task[:usage]]).join(', ')}"
  puts "(type rake -T for more detail)\n\n"
end

namespace "dev" do |ns|

  desc "Build gempspec"
  task :build do
    sh "gem build #{gem}.gemspec"
  end

  desc "To run when everything is in version control ok"
  task "full-delivery" => [ "rt:release", "rt:push", "rt:snapshot" ]


end 
