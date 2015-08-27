# [aws-must-templates](https://github.com/jarjuk/aws-must-templates) - tests
## smoke - Fails fast if problems with AWS installation


Creates a S3 bucket, and no EC2 instances. 


### Stack Parameters and Outputs

<pre>

AwsMustTestRunnerProperties
  System properties
    property with keys [:stack_id]
      value
        should not eq nil
    property with keys [:suite_id]
      value
        should not eq nil
    property with keys ["Outputs"]
      value
        should not eq nil
    property with keys ["Parameters"]
      value
        should not eq nil

ParameterTest
  Test parameter definition
    Test parameter 'param1' for role 'ParameterTest'
      definition_in_test_suite
        should not eq nil
    Test parameter 'param2' for role 'ParameterTest'
      definition_in_test_suite
        should not eq nil
    Test parameter 'param3' for role 'ParameterTest'
      definition_in_test_suite
        should not eq nil

Stack
  Stack 'smoke'
    #known in test 'Stack''
    Stack parameter 'DummyParameter'
      value
        should not eq nil
    Stack output 'Bucket'
      value
        should not eq nil
    Stack output 'BucketName'
      value
        should not eq nil

Finished in 0.00642 seconds (files took 1.17 seconds to load)
11 examples, 0 failures

</pre>


### Instance Test Reports

## suite1 - EC2 instance with S3 read access


Creates an S3 bucket and two EC2 instances (myInstance, myInstance2)
One of the instances (myInstance) is granted Read Access Rights to the Bucket.

To grant Access Rights 

* create a Role
* create Policy referencing the Role
* create an InstanceProfile referencing the Role
* associate the InstanceProfile to the EC2 instance to grant Read Access

Creates SecurityGroup to act as a virtual firewall, and to allow ssh
connection to the EC2 instance.

EC2 installation uses UserData script to install

* AWS Command Line Interface
* CloudFormation Helper Scripts. These scripts are used to create
  notification when installation is finished


### Stack Parameters and Outputs

<pre>

Stack
  Stack 'suite1'
    #known in test 'Stack''
    Stack output 'Bucket'
      value
        should not eq nil
    Stack parameter 'InstanceType'
      value
        should not eq nil
    Stack parameter 'KeyName'
      value
        should not eq nil
    Stack parameter 'SSHLocation'
      value
        should not eq nil

Finished in 0.00336 seconds (files took 1.06 seconds to load)
5 examples, 0 failures

</pre>


### Instance Test Reports

* [myInstance](suites/suite1-myInstance.txt)
* [myInstance2](suites/suite1-myInstance2.txt)
