# -*- mode: ruby -*-

guard :rspec, cmd: 'bundle exec rspec'  do

  watch(%r{^spec/mustache/.+_spec\.rb$})
  watch(%r{^mustache/(.+)\.mustache$})                       { |m| "spec/mustache/#{m[1]}_spec.rb" }

end
