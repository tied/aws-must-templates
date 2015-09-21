# -*- mode: ruby -*-

require 'stringio'
require_relative "lib/tasks/cross-ref"

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

# name of configuration file
suite_runner_configs= "suite-runner-configs.yaml"

# Override configuration in 'suite.rake' 
$suite_runner_configs = File.exist?(suite_runner_configs) ? YAML.load_file( suite_runner_configs ) : {}

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
  
  # ------------------------------------------------------------------
  # docs
  
  namespace "docs" do |ns|

    task :clean do

      files =   FileList[ "#{generate_docs_dir}/**/*"]
      files.exclude { |f|  File.directory?(f) }
      # do not clean test reports
      files.exclude( suite_test_report_dirpath() )

      rm_rf files unless files.empty?

    end

    # xref
    desc "Test cases vs. test suites"
    task :xref, :stdout  do |t,args|
      
      test_reports = FileList[ "#{suite_test_report_dirpath()}/*" ]
      xref_suite_X_test, xref_test_X_suite = build_cross_refs( test_reports )

      # puts "xref_suite_X_test=#{xref_suite_X_test}"
      # puts "xref_test_X_suite=#{xref_test_X_suite}"

      dot_file = "#{generate_docs_dir}/tmp/xref_suite_X_test.dot"
      capture_stdout_to( dot_file ) {  xref_to_dot( xref_suite_X_test, xref_test_X_suite )     } 

      pdf_file = "#{generate_docs_dir}/xref_suite_X_test.pdf"

      # sh "dot #{dot_file} -T pdf > #{pdf_file}"
      sh "neato #{dot_file} -T pdf > #{pdf_file}"

    end # task :xref

    # default suite.rake configurations
    desc "Test cases vs. test suites"
    task "suite-runner-configs"  do

      file = "#{generate_docs_dir}/suite-runner-configs.yaml"
      sh "rake suite:suite-runner-configs > #{file}"
    end



    # tests
    desc "Markdown documention for tests in 'test-suites.yaml'"
    task :tests, :stdout  do |t,args|

      file = "#{generate_docs_dir}/test-suites.md" unless ( args.stdout )

      capture_stdout_to( file ) { 

        puts "# <a id='top'/>[aws-must-templates](https://github.com/jarjuk/aws-must-templates) - tests"
        
        # ----------------------------------------
        # table of content
        puts "## Test suites"
        
        puts "\n"
        test_suites.suite_ids.each do |suite_id|
          suite = test_suites.get_suite( suite_id )
          puts "* [#{suite_header_txt( suite_id, suite)}](#{suite_link_target(suite_id)})"
        end
        puts "\n\n"
        
        # ----------------------------------------
        # iterate suites, for each suite output 
        # - long description
        # - suite common tests data (=parameters, outputs sections)
        # - instance tests

        test_suites.suite_ids.each do |suite_id|
          
          suite = test_suites.get_suite( suite_id )

          # puts "## #{suite_id} - #{suite['desc']}"
          puts "## #{suite_header(suite_id, suite)}"
          puts ""
          puts suite['long_desc']
          puts ""
          puts ""

          if File.exist?( suite_test_report_filepath( suite_id ) ) then

            puts "### Stack Parameters and Outputs"
            puts ""
            puts "<pre>"
            sh "cat #{suite_test_report_filepath( suite_id )}"
            puts "</pre>"
          end 

          puts ""
          puts ""

          puts "### Instance Test Reports"
          puts ""

          # iterate suite instancess to create a link to test report
          test_suites.suite_instance_names( suite_id ).each do |instance_name|
            puts "* [#{suite_id}-#{instance_name}](#{suite_test_report_link(suite_id,instance_name)})"
          end

          test_suites.suite_instance_names( suite_id ).each do |instance_name|
            puts "\n\n"
            puts "#{suite_test_report_header(suite_id,instance_name)}"
            puts "\n\n<pre>"
            sh "cat #{suite_test_report_filepath( suite_id, instance_name )}"
            puts "</pre>\n\n"
            
          end
          

        end # each suite_ids
      } # capture stdout


    end

    # Document specs
    desc "RSPEC documention for spec/aws-must-templates"
    task "spec" do
      file = "#{generate_docs_dir}/aws-must-templates-spec.html"
      spec_glob = "spec/aws-must-templates/**/*_spec.rb"
      table_of_contents_template = "spec/aws-must-templates/table_of_content"
      capture_stdout_to( file ) { sh "#{aws_must} ddoc '#{spec_glob}' --table_of_content=#{table_of_contents_template}| markdown" }
    end

    
    # mustache templates --> html documentation
    desc "HTMl documention for mustache templates"
    task "mustache" do
      file = "#{generate_docs_dir}/aws-must-templates.html"
      capture_stdout_to( file ) { sh "#{aws_must} doc | markdown" }
    end

    # stack YAML --> CloudFormation Json
    desc "CloudFormation JSON templates for tests in 'test-suites.yaml'"    
    task :cf, :stack do |t,args|

      sh "mkdir -p #{stack_json_template_dirpath}" unless File.exists?(stack_json_template_dirpath)

      if args.stack 
        stack_id = args.suite
        file = stack_json_template_filepath( stack_id ) # "#{generate_docs_dir}/#{stack_id}.json"
        capture_stdout_to( file ) { sh "#{aws_must} gen #{stack_id}.yaml -m mustache/ | jq ." }
      else
        test_suites.stack_ids.each do |stack_id|
          file = stack_json_template_filepath( stack_id )
          capture_stdout_to( file ) { sh "#{aws_must} gen #{stack_id}.yaml -m mustache/ | jq ." }
        end
        
      end

    end # task cf

  end # ns docs

  desc "Generate html-, stack CloudFormation JSON templates into `{generate_docs_dir}` -subdirectory"
  task :docs => ["dev:docs:mustache", "dev:docs:suite-runner-configs", "dev:docs:spec", "dev:docs:cf", "dev:docs:tests", "dev:docs:xref" ]

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

    desc "Launch guard"
    task :guard do
      sh "bundle exec guard"
    end

  end # ns 

  desc "Run unit tests"  
  task :rspec => ["dev:rspec:mustache", "dev:rspec:lib" ]


  # ------------------------------------------------------------------
  # Build && delivery

  desc "Build gempspec"
  task :build do
    sh "gem build #{gem}.gemspec"
  end

  desc "Install locally"
  task :install do
    version = version()
    sh "gem install ./#{gem}-#{version}.gem"
  end

  desc "Push to RubyGems"
  task :push do
    version = version()
    sh "gem push ./#{gem}-#{version}.gem"
  end

  desc "Finalize delivery"
  task "fast-delivery" => [ "dev:rspec", "dev:docs", "rt:release", "rt:push", "dev:build", "dev:install", "rt:snapshot" ]

  desc "Run all tests suites && create delivery"
  task "full-delivery" => [ "suite:all", "dev:fast-delivery" ]

  desc "Finalize (in master branchs after merge)"
  task :finalize => [ "rt:push", "dev:push", "dev:upload-gist" ]

  # ------------------------------------------------------------------
  # gists 


  desc "Upload generated-docs to (existing) gists "
  task "upload-gists"  do

    # directory
    gist_names_dir  = "#{generate_docs_dir}/gist-names"
    sh "mkdir -p #{gist_names_dir}" unless File.exists?(gist_names_dir)

    # config
    gist_names = 
      [
       { :name => "aws-must-templates-suites",
         :description => "Rspec test reports for [aws-must-templates](https://github.com/jarjuk/aws-must-templates)",
         :files => [ "#{generate_docs_dir}/suites/*" ],
         :url=>"724b259de6af031493b7"
       },
       { :name => "aws-must-templates-cf-templates",
         :description => "Cloudformation templates from [aws-must-templates](https://github.com/jarjuk/aws-must-templates)",
         :files => [ "#{generate_docs_dir}/cloudformation/*"  ],
         :url=>"9fe4d74b42fd6f272aad" 
       },
       { :name => "aws-must-templates-test-report",
         :description => "Test report from running test suites in [aws-must-templates](https://github.com/jarjuk/aws-must-templates) development",
         :files => [ "#{generate_docs_dir}/test-suites.md"  ],
         :url=>"9ab1c25d436c4e468f5e",
       },
      ]

    # iterate && upload
    gist_names.each do |gist_name|
      gist_name_file = "#{gist_names_dir}/#{gist_name[:name]}.md"
      File.open( gist_name_file, 'w') { |f| f.write("#{gist_name[:description]}\n") }
      gist_url = "https://gist.github.com/jarjuk/#{gist_name[:url]}"
      sh "gist -u #{gist_url} #{gist_name_file} #{gist_name[:files].join( ' ' )}" if gist_name[:url]
    end
    
    
  end # task gist


  # ------------------------------------------------------------------
  # site

  task :site_cp do

    site_dir         ="#{ENV['HOME']}/apache/site/#{@module_name}"

    def site_cp( site_dir, site_files )
      site_files.each do |file|
        site_file="#{site_dir}/#{file}"
        puts "site_cp=#{file} -->  #{site_file}"
        sh "cp #{file} #{site_file}" if 
          !File.exists?(site_file) or File.mtime( file ) > File.mtime(site_file)
      end
    end

    site_files = Rake::FileList[ "*.md", "*.yaml" "pics/*.jpg"]
    site_cp( site_dir, site_files )

  end

end 

# ------------------------------------------------------------------
# common methods

# if file defined, redirect stdout (temporaliy) to file 
def capture_stdout_to( file )
  if file == '-' then
    real_stdout = $stdout
    $stdout = StringIO.new('','w')
    $stdout.sync = true
  elsif file  then
    real_stdout = $stdout.clone
    $stdout.reopen( file )
    $stdout.sync = true
  end
  yield
  if file == '-' then
    $stdout.string
  end
ensure
  if file  == '-'
    $stdout = real_stdout
    $stdout.sync = true
  elsif file 
    $stdout.reopen( real_stdout )
    $stdout.sync = true
  end
end

# path to file where suite_id common output
def suite_test_report_filepath( suite_id, instance_name=nil )
  "generated-docs/suites/#{suite_id}#{ instance_name ? '-' + instance_name : ""}.txt"
end

# relative link to test report
def suite_test_report_link( suite_id, instance_name=nil )
  # "suites/#{suite_id}#{ instance_name ? '-' + instance_name : ""}.txt"
  "\##{suite_id}#{ instance_name ? '-' + instance_name : ""}"
end

def suite_test_report_header( suite_id, instance_name=nil )
  id= "#{suite_id}#{ instance_name ? '-' + instance_name : ''}"
  "\#\#\#\# <a id=\"#{id}\">#{id} - #{top_link} - #{suite_link(suite_id)}"
end

def suite_header( suite_id, suite )
  "<a id=\"#{suite_id}\">#{suite_header_txt( suite_id, suite)} - #{top_link}"
end

def suite_header_txt( suite_id, suite )
  "#{suite_id} - #{suite['desc']}"
end


def top_link
  "<a class='navigator' href='#top'>[top]</a>"
end

def suite_link( suite_id )
  "<a class='navigator' href='#{suite_link_target(suite_id)}'>[#{suite_id}]</a>"
end

def suite_link_target( suite_id )
  "\##{suite_id}"
end


# location of test run reports
def suite_test_report_dirpath
  "generated-docs/suites"
end

# path to cloudformation stack
def stack_json_template_filepath( stack_id  )
  "#{stack_json_template_dirpath}/#{stack_id}.json"
end

def stack_json_template_dirpath
  "generated-docs/cloudformation"
end


