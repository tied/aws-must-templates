# aws-must-templates - cloudformation templates for aws-must - $Release:0.0.7-SNAPSHOT$

CloudFormation
[templates](https://rawgit.com/jarjuk/aws-must-templates/master/generated-docs/aws-must-templates.html)
for [aws-must](https://github.com/jarjuk/aws-must).

## The Problem

When using template generators, consider

1. Template generators are much like a "Garden Party"/"You see, ya
   can't please everyone, so ya got to please yourself": Most of the
   things that you need are there, but some specific feature is
   missing, or should be implemented in a different way.

2. You can't say that a "Day is Done" just by having an
   implementation. Implementation without validating correctness is
   asking for trouble.

3.  Avoid "Vanishing Mind" syndrome in testing, i.e.  failing to reuse
    existing tests.  After all, we are relying on a template
    generator, which is hopefully comprehensively tested. The test
    mechanism and test suites should be available also for template
    generator users.
  
4. When reusing tests: "Do You Remember"/"It All Starts With One". We
   need to be able to extend also the tests that come along with the
   generator.

## The solution

**aws-must-templates** tries to address the above listed considerations

1. by allowing user to override templates used in generation

2. implementing  [test-suites.yaml](test-suites.yaml) configuration,
   which allows defining [serverspec](http://serverspec.org/) test
   suites

3. [test-suites.yaml](test-suites.yaml) configuration may refer to
   test sets cataloged in ???, test input variables may be mapped

4. user may write their own serversepc test and refer to these in
   *test-suites.yaml* configuration



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
  
For a configuration walk trough see blog post
[Announcing aws-must-templates – part 1](https://jarjuk.wordpress.com/2015/08/18/announcing-aws-must-templates-part1)

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

### Generate CloudFormation JSON template

To print out CloudFormation JSON template for `smoke.yaml` using
[mustache templates](https://mustache.github.io/mustache.5.html)
stored in directory `mustache`.

	bundle exec aws-must.rb gen smoke.yaml
	
### Create template documentation	

To extract HTML -documentation starting from `root.mustache` in
directory `mustache`


	bundle exec aws-must.rb doc | markdown
	
Rake task

	bundle exec rake dev:docs
	
generates html documentation into `aws-must-templates.html` -file in
`generated-docs` -directory.

### Run unit tests

Template unit tests are stored in directory `spec/mustache`. All unit
test are executed with the command

	rake dev:rspec


To launch Guard monitor, which triggers unit test to run automatically
on a template change, issue the command

    rake dev:guard
	
in a new terminal window.


### Implement a test suite

Test suite implementation includes

* adding a test suite into [test-suites.yaml](test-suites.yaml).
* a YAML configuration defining CloudFormation stack
* defining instance credentials in `ssh/config` 
* writing serverspec tests in `spec` directory


**add a test suite into test-suites.yaml**

Test suites are defined [test-suites.yaml](test-suites.yaml)
-configuration file.


For example, the definition of `suite1` is 

    - suite1:
       desc: EC2 instance with s3 access
       instances:
         - myInstance:
             roles:
               - Stack
               - AwsCommandLineInterfaceInstalled
               - CloudFormationHelperScriptsInstalled
               - S3ReadAccessAllowed
    
         - myInstance2:
             roles:
              - Stack
              - AwsCommandLineInterfaceInstalled
              - CloudFormationHelperScriptsInstalled
              - S3NoAccess


This configuration lists two instances `myInstance` and
`myInstance2`. The examples says that `myInstance` should pass four
[serverspec](http://serverspec.org/) test sets `Stack`,
`AwsCommandLineInterfaceInstalled`,
`CloudFormationHelperScriptsInstalled` and `S3ReadAccessAllowed`.


**a YAML defining CloudFormation stack**

Each suite is has an associated CloudFormation stack configuration in
a YAML file.

For example, the CloudFormation stack of `suite1` is in YAML file
[suite1.yaml](suite1.yaml).


**define instance credential in 'ssh/config'**

Ssh configuration file `ssh/config` should define an entry for each
suite instance to allow serverspec to authenticate a ssh connection to
the instance.


For example, `suite1` in [test-suites.yaml](test-suites.yaml) defines
an EC2 instance `myInstance`, and file `ssh/config` contains following
entry:
 
     host myInstance
         StrictHostKeyChecking no
         UserKnownHostsFile=/dev/null
         user ubuntu
         IdentityFile ~/.ssh/demo-key/demo-key


In this example, [suite1.yaml](suite1.yaml) uses parameter `KeyName`
to allow ssh key `demo-key` to authenticate a ssh session to `myInstance`.

Parameters `UserKnownHostsFile` and `StrictHostKeyChecking` prevent
ssh from updating your default `.ssh/known_hosts` file with the
fingerprint of the (temporary) instance used in testing.

**write serverspec tests**

Suite tests are defined using `roles` attributes in
[test-suites.yaml](test-suites.yaml) configuration file. The attribute
lists names pointing to sub-directories of `spec` -directory.  The
sub-directories contain [serverspec](http://serverspec.org/) tests,
which the suite should pass.

Test are implemented using
[default serverspec resource types](http://serverspec.org/resource_types.html)
or custom resource types defined in `spec/support/lib`.


### Prepare aws-account for running test suites

For a test suite to run successfully, you need to
[import](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#how-to-generate-your-own-key-and-import-it-to-aws)
key pairs used in the suite to Amazon.

For example, [suite1.yaml](suite1.yaml) uses parameter `KeyName` to
define a key name `demo-key`.


### Running test suites

**WARNING** Running tests provisions Amazon platform, and will be
**charged according to Amazon pricing policies**.

The command

	rake suite:all

iterates all test suites defined in
[test-suites.yaml](test-suites.yaml).

For each test suite, the command generates a CloudFormation JSON
template, uses it to provision the stack on Amazon platform, and, once
the `StackStatus` is `CREATE_COMPLETE`, runs test sets defined for the
suite instances. Finally, after the test execution, the stack is
deleted from Amazon platform.

Command

	rake -T suite 
	
list of tasks `rake suite:all` uses for implementation.

**NOTICE** It advisable to check on AWS console that all stack
  resources are deleted successfully after the test suites.


## Changes

See [RELEASES](RELEASES.md)

## TODO

Add more tests, e.g.

* VPC and subnets
* install Chef

Add more template support

* support for SNS notifications


## License 

MIT



