# aws-must-templates - cloudformation templates for aws - $Release:0.0.3-SNAPSHOT$

CloudFormation
[templates](https://rawgit.com/jarjuk/aws-must-templates/master/generated-docs/aws-must-templates.html)
for [aws-must](https://github.com/jarjuk/aws-must).


## Usage

### Installation

Add following lines to `Gemfile`


    source 'https://rubygems.org'
	gem 'aws-must'
	gem 'aws-must-templates', git: 'git@repo:aws-must-templates.git'
	
and run

	bundle install
	
**Notice**: requires Ruby version ~> 2.0.

### Configuration

Create a YAML configuration file defining a CloudFormation stack using
attributes referenced by
[aws-must-templates](https://rawgit.com/jarjuk/aws-must-templates/master/generated-docs/aws-must-templates.html).

Most likely the easiest way to start, is to take a look at test suite
configuration: 

* [smoke.yaml](smoke.yaml): creates S3 bucket 

* [suite1.yaml](suite1.yaml): create two EC2 instances, one of which
  is granted an access a S3 bucket



### 

## Test suites

Templates are are 


A YAML configuration defines [test suites](test-suites.yaml). See the 

, which
may be executed using the command

	rake suite:all
	
This command will:

* cleanup CloudFormation templates in directory `rake suite:json-clean`
* run test suites in the same sequence 


which defines an array of suites, with following properties

* `desc` - one liner summarizing suite purpose
* `roles` - an array of common tests 


## Usage

Create a YAML file for configuration.

[demo:html-7](https://rawgit.com/jarjuk/aws-must/master/generated-docs/7.html)



## Development

See [RELEASES](RELEASES.md)


## License 

MIT



