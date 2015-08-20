## 0.0.7-SNAPSHOT/20150820-09:37:28

* spec/S3ReadAccessAllowed/S3ReadAccessAllowed_spec.rb: Added tests
  "Cannot write bucket" "Cannot modify bucket"
* template changes
  	* mustache/resourceInstanceInitialize.mustache: LOG output fixed
* Documentation fixes:
  * mustache/resourceS3Bucket.mustache: Fixed documentation (removed
	with default 'PublicRead')

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
