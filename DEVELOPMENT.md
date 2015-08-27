## Clone

To clone the repo

	git clone https://github.com/jarjuk/aws-must-templates
	
and to install dependencies

	cd aws-must-templates
	bundle install

### Run unit tests

Template unit tests are stored in directory `spec/mustache`. All unit
test are executed with the command

	rake dev:rspec


To launch Guard monitor, which triggers unit test to run automatically
on a template change, issue the command

    rake dev:guard
	
in a new terminal window.


## Create template documentation

Documentation tasks are shown with the command

	rake -T dev:docs

** Mustache template documentation**

To extract HTML -documentation starting from `root.mustache` in
directory `mustache`


	bundle exec aws-must.rb doc | markdown
	
Rake task

	bundle exec rake dev:docs:mustache
	
generates html documentation into `aws-must-templates.html` -file into
the `generated-docs` -directory.

** JSON templates for test suites **

To print out CloudFormation JSON template for `smoke.yaml` using
[mustache templates](https://mustache.github.io/mustache.5.html)
stored in directory `mustache`.

	bundle exec aws-must.rb gen smoke.yaml
	
A rake task

	rake dev:docs:cf
	
iterates all test cases in `test-suites.yaml` and generates json
example into
