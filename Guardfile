# -*- mode: ruby -*-

guard :rspec, cmd: 'bundle exec rspec'  do

  # Mustache templates
  watch(%r{^spec/mustache/.+_spec\.rb$})
  watch(%r{^mustache/(.+)\.mustache$})                       { |m| "spec/mustache/#{m[1]}_spec.rb" }


end

guard :rspec, cmd: 'bundle exec rspec'  do

  # TestSuites
  watch(%r{^spec/lib/.+_spec\.rb$})
  watch(%r{^lib/.+/(.+)\.rb$})                                  { |m| "spec/lib/#{m[1]}_spec.rb" }
  

end
