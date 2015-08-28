## 0.1.3-SNAPSHOT/20150827-15:24:01

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
