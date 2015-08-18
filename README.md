# aws-must-templates - cloudformation templates for aws - $Release:0.0.4-SNAPSHOT$

CloudFormation
[templates](https://rawgit.com/jarjuk/aws-must-templates/master/generated-docs/aws-must-templates.html)
for [aws-must](https://github.com/jarjuk/aws-must).

## Usage

### Installation

Add the following lines to `Gemfile`

    source 'https://rubygems.org'
	gem 'aws-must'
	gem 'aws-must-templates', git: 'git@repo:aws-must-templates.git'
	
and run

	bundle install
	
**Notice**: requires Ruby version ~> 2.0.

### Configuration

Create a YAML configuration for a CloudFormation stack using
attributes referenced by
[aws-must-templates](https://rawgit.com/jarjuk/aws-must-templates/master/generated-docs/aws-must-templates.html).

The easiest way to start, is to take a look at test suite stack YAML configuration files:

* [smoke.yaml](smoke.yaml): creates a S3 bucket

* [suite1.yaml](suite1.yaml): creates two EC2 instances, and one S3
  bucket, one of the instances (`myInstance`) which is granted a read
  access to the S3 bucket

### Generate CloudFormation JSON templates

Assuming a YAML stack configuration in a file `mystack.yaml`, the
command

	bundle exec	aws-must.rb gen mystack.yaml  -g aws-must-templates 
	
prints the CloudFromation JSON template to STDOUT.

### Provision the stack on Amazon platform

**WARNING** Provisioning CloudFormation templates on Amazon will be
**charged according to Amazon pricing policies**.

Assuming the [aws command line utility](https://aws.amazon.com/cli) is
[correctly setup](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-set-up.html),
the command

	aws cloudformation create-stack --stack-name mystack  --capabilities CAPABILITY_IAM  --template-body "$(bundle exec	aws-must.rb gen mystack.yaml  -g aws-must-templates)"  --disable-rollback

provisions a stack `mystack` from YAML config `mystack.yaml ` on the
Amazon platform.

## Development

### Clone

To clone the repo

	git clone https://github.com/jarjuk/aws-must-templates
	
and to install dependencies

	cd aws-must-templates
	bundle install

### Templates

To print out CloudFormation JSON template for `smoke.yaml` using
[mustache templates](https://mustache.github.io/mustache.5.html)
stored in directory `mustache`.

	bundle exec aws-must.rb gen smoke.yaml

To extract HTML -documentation starting from `root.mustache` in
directory `mustache`


	bundle exec aws-must.rb doc | markdown


### Setup aws-account for running test suites

Test configurations (e.g. [e.g. suite1.yaml](suite1.yaml)) refer to
EC2 key pair with a name `demo-key`. For the test suites to run
successfully, you need to
[import a Key Pair to Amazon](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#how-to-generate-your-own-key-and-import-it-to-aws)
with the name `demo-key`.

### Configuring test suites

Configuration for a test suite include

* an entry in [test-suites.yaml](test-suites.yaml).
* a YAML configuration defining CloudFormation stack
* an entry in `ssh/config` -file for each instance defined in
  [test-suites.yaml](test-suites.yaml)


#### Configure test-suites.yaml

For example, `suite1` is defined in [test-suites.yaml](test-suites.yaml)

    - suite1:
       desc: EC2 instance with s3 access
       instances:
         - myInstance:
             roles:
               - 001-stack
               - s3reader
    
         - myInstance2:
             roles:
              - 001-stack


The configuration defines two instances `myInstance` and
`myInstance2`.  `myInstance` should pass two
[serverspec](http://serverspec.org/) test sets `001-stack` and
`s3reader`, which can are located under `spec` directory.



#### Configure YAML defining CloudFormation stack

The YAML configuration defining CloudFormation stack for `suite1` is
in file [suite1.yaml](suite1.yaml).


#### Configure instance credential in 'ssh/config'

[test-suites.yaml](test-suites.yaml) names an EC2 instance
`myInstance`, and the ssh-configuration needed by serverspec to access
the instance is defined `ssh/config` as
 
     host myInstance
         StrictHostKeyChecking no
         UserKnownHostsFile=/dev/null
         user ubuntu
         IdentityFile ~/.ssh/demo-key/demo-key


In this example `demo-key` was defined in [suite1.yaml](suite1.yaml),
allowing a ssh-connection to the instance.

Parameters `UserKnownHostsFile` and `StrictHostKeyChecking` prevent
ssh from updating your default `.ssh/known_hosts` file for the
instance used in testing.


### Running Test suites

**WARNING** Running tests provisions Amazon platform, and will be
**charged according to Amazon pricing policies**.

The command

	rake suite:all

iterates all test suites defined in
[test-suites.yaml](test-suites.yaml).

For each test suite, the command generates a CloudFormation JSON
template, uses it to provision the stack on Amazon platform, and, once
the `StackStatus` is `CREATE_COMPLETE`, runs serverspec defined in the
configuration. Finally, the stack is deleted from Amazon platform.

Please, refer the output of

	rake -T suite 
	
for list of tasks executed by the `rake suite:all` -command.

**WARNING** It advisable to check on AWS console that stack resources
  are deleted successfully after tests.


## Changes

See [RELEASES](RELEASES.md)


## License 

MIT



