## 0.2.3-SNAPSHOT/20150921-14:02:36
## 0.2.2/20150921-14:02:09

* include test-suites to bundle

## 0.2.1/20150918-14:57:08


* Template chanages
  *
	[mustache/resourceInternetGateway.mustache](https://rawgit.com/jarjuk/aws-must-templates/master/generated-docs/aws-must-templates.html#resourceInternetGateway.mustache)
	 * Attachement defined using `Attachment` subdocument, 
	 * Tags array: always defines Key/Value pair with Key="Name", support "SourceDestCheck" attribute
	
  * [mustache/commonDependsOn.mustache](https://rawgit.com/jarjuk/aws-must-templates/master/generated-docs/aws-must-templates.html#commonDependsOn.mustache): support array of resources
  * [mustache/resourceInstance.mustache](https://rawgit.com/jarjuk/aws-must-templates/master/generated-docs/aws-must-templates.html#resourceInstance.mustache): 
    * Tags array: always defines Key/Value pair with Key="Name", support "SourceDestCheck" attribute
	* support for attribute `DependsOn`
  *
    [mustache/resourceSubnet.mustache](https://rawgit.com/jarjuk/aws-must-templates/master/generated-docs/aws-must-templates.html#resourceSubnet.mustache):
    support `RoutetableAssociation` attribute
  * [mustache/resourceSecurityGroup.mustache](https://rawgit.com/jarjuk/aws-must-templates/master/generated-docs/aws-must-templates.html#resourceSecurityGroup.mustache): Support for SecurityGroupEgress
     use  [commonXGressRule.mustache](https://rawgit.com/jarjuk/aws-must-templates/master/generated-docs/aws-must-templates.html#commonXGressRule.mustache), support 
	 * Tags array: always defines Key/Value pair with Key="Name"
  
  * refractored
    * [commonValue.mustache](https://rawgit.com/jarjuk/aws-must-templates/master/generated-docs/aws-must-templates.html#commonValue.mustache) includes
      [commonRef.mustache](https://rawgit.com/jarjuk/aws-must-templates/master/generated-docs/aws-must-templates.html#commonRef.mustache)


  * new templates
    * [resourceRoute.mustache](https://rawgit.com/jarjuk/aws-must-templates/master/generated-docs/aws-must-templates.html#resourceRoute.mustache) 
    * [resourceRouteTable.mustache](https://rawgit.com/jarjuk/aws-must-templates/master/generated-docs/aws-must-templates.html#resourceRoute.mustache) 
	* [mappingAmazonVpcNat.mustache](https://rawgit.com/jarjuk/aws-must-templates/master/generated-docs/aws-must-templates.html#mappingAmazonVpcNat.mustache) 


* Lots of new [serverspec tests](https://rawgit.com/jarjuk/aws-must-templates/master/generated-docs/aws-must-templates-spec.html)
  * [Ec2InstanceType](https://rawgit.com/jarjuk/aws-must-templates/master/generated-docs/aws-must-templates-spec.html#Ec2InstanceType)
  * [Ec2PrivateIp](https://rawgit.com/jarjuk/aws-must-templates/master/generated-docs/aws-must-templates-spec.html#Ec2PrivateIp)
  * [Ec2PublicIp](https://rawgit.com/jarjuk/aws-must-templates/master/generated-docs/aws-must-templates-spec.html#Ec2PublicIp)
  * [Ec2Routes](https://rawgit.com/jarjuk/aws-must-templates/master/generated-docs/aws-must-templates-spec.html#Ec2Routes)
  * [Ec2SecurityGroups](https://rawgit.com/jarjuk/aws-must-templates/master/generated-docs/aws-must-templates-spec.html#Ec2SecurityGroups)
  * [Ec2StatusNormal](https://rawgit.com/jarjuk/aws-must-templates/master/generated-docs/aws-must-templates-spec.html#Ec2StatusNormal)
  * [NetworkCanPing](https://rawgit.com/jarjuk/aws-must-templates/master/generated-docs/aws-must-templates-spec.html#NetworkCanPing)
  * [RespondsToPing](https://rawgit.com/jarjuk/aws-must-templates/master/generated-docs/aws-must-templates-spec.html#RespondsToPing)


* Test Runner
  * `rake suite:<instance_id>-sync`: rake task to sychronize
    synchronize EC2 Tag Name/DNS Name to SSH client configuration file
    into `ssh/config.aws`
  * missing region -fixed
  
* Documetation   
  * added [diagrams](https://rawgit.com/jarjuk/aws-must-templates/master/generated-docs/aws-must-templates-spec.html)

* Implementation changes
  * use [aws-ssh-resolver](https://github.com/jarjuk/aws-ssh-resolver)
    to synchronize EC2 Tag Name/DNS Name to SSH client configuration
    file in `ssh/config.aws`, use `ssh/config.init` to initialize
	

## 0.1.7/20150902-11:46:24

* Added task `rake dev:docs:spec`
* Use `aws-must.rb >=0.0.14`

## 0.1.6/20150901-15:00:45

* Clarfications in README, link to blog posts
* Depencecies clarified in `aws-must-templates.gemspec`
* Running `rake suite:mystack:myInstance` when no roles defined
  results to `NoMethodError: undefined method `[]' for nil:NilClass`
  --> better error message should be outputted


## 0.1.5/20150828-13:06:34

- rake suite:report_dir - fixed

## 0.1.4/20150828-12:46:39

- rake dev:fast-delivery- added rspec


## 0.1.3/20150828-10:38:02

* added Dir.glob("spec/**/*") to Gem (could not run tests with)
* some minor documetation changes
* add home page in Gem

## 0.1.2/20150827-15:23:33

* first version to RubyGems

## 0.1.1/20150827-14:59:40

* Documentation fixes
  * fixed link to instance test reports `test-suites.md`
  * use `generated-docs/xref_suite_X_test.pdf` instead of
    `generated-docs/xref_suite_X_test.eps`
* Prepare to push to Rubygems

## 0.1.0/20150827-14:33:07

* Major changes:
  * adds instruction && support for user to override template impelemtation
  * adds instruction && support for user to use test runner `suite.rake`
  * adds [test report](generated-docs/test-suites.md)
  * adds unit tests and rake tasks `rake dev:rspec`
    * to test templates in `mustache` directory, tests in `spec/mustache`
    * to ruby code  `lib` directory, tests in `spec/lib`

* Refractored code base
  * serverspec tests in directory `spec/aws-must-templates`
  * cloudformation tempates generated in directory
    `generated-docs/cloudformation/`

* Some minor changes
  * Added && modified tests serverspec tests
  * template changes
  * Documentation fixes

## 0.0.6/20150820-09:37:27

* Reorganized tests in spec directory
  * Added `AwsCommandLineInterfaceInstalled`
  * Added `CloudFormationHelperScriptsInstalled`
  * Added `S3NoAccess`
  * Renamad `Stack`, `S3ReadAccessAllowed`
* Add Custom Resource Type `valid_property( props, keys )`
* Add example [suite1 json](generated-docs/suite1.json) using task `rake dev:docs`
* UserData scripts do not use LOG (just output to stdout and find log in user-data.log
* fixed gemspec to include templates from mustache directory (prev. templates)

## 0.0.5/20150819-09:55:07

* Documentation enhancements

## 0.0.4/20150818-16:22:48

* Documentation enhancement in README.md

## 0.0.3/20150818-12:17:02

* `Policy` (defined in template `mustache/resourcePolicy.mustache`),
  attribute `Resource` is an Array of commonValues (previously array
  of strings)

## 0.0.2/20150818-10:26:33


## 0.0.1/20150814-11:29:48

* fist version


## 0.0.0/18.00.2013

- Base release
