=begin

+++start+++

## <a id="Ec2InstanceType"></a>Ec2InstanceType<a class='navigator' href='#top'>[top]</a>

Validates `InstanceType`  of EC2 `InstanceId` as returned by  `describe_instance_attribute` 

* `:instance_type` == `InstanceType`

**Parameters**

- `test_parameter( current_test, "InstanceType" )` 

+++close+++

=end

# +++fold-on+++

require 'spec_helper'

current_test = File.basename File.dirname  __FILE__ 

describe current_test do

  # ------------------------------------------------------------------
  # test parameters

  instance = suite_value( :instance_name )   # set in spec_helper
  instanceType = test_parameter( current_test, "InstanceType" )

  # ------------------------------------------------------------------
  # tests
  describe "instance '#{instance.value}'" do


    describe ec2_named_resource( instance ) do
      its( :instance_type  ) { should eq instanceType.value }
    end

  end


end

# +++fold-off+++
