=begin

+++start+++

## <a id="Ec2InstanceType"></a>Ec2InstanceType<a class='navigator' href='#top'>[top]</a>

Validates `InstanceType`  of EC2 `InstanceId` as returned by  `describe_instance_attribute` 

* `:instance_type` == `InstanceType`
* `:instance_id` == `InstanceId`  # no brainer

**Parameters**

- `test_parameter( current_test, "InstanceId" )` 
- `test_parameter( current_test, "InstanceType" )` 

+++close+++

=end

# +++fold-on+++

require 'spec_helper'

current_test = "Ec2InstanceType"

describe current_test do

  # ------------------------------------------------------------------
  # test parameters

  instance = test_parameter( current_test, "InstanceId" )
  instanceType = test_parameter( current_test, "InstanceType" )

  # ------------------------------------------------------------------
  # tests
  describe "instance '#{instance.value}'" do


    describe ec2_resource( instance ) do
      its( :instance_type  ) { should eq instanceType.value }
    end

    describe ec2_resource( instance ) do
      its( :instance_id  ) { should eq instance.value }
    end

  end


end

# +++fold-off+++
