=begin

+++start+++

## <a id="Ec2StatusNormal"></a>Ec2StatusNormal<a class='navigator' href='#top'>[top]</a>

Validates that status of `InstanceId` EC2  status for `describe_instance_status` normal:

* `:system_status_ok?`
* `:instance_state_running?`

**Parameters**

- `test_parameter( current_test, "InstanceId" )` 



+++close+++

=end

# +++fold-on+++

require 'spec_helper'

current_test = "Ec2StatusNormal"

describe current_test do

  # ------------------------------------------------------------------
  # test parameters

  instance = test_parameter( current_test, "InstanceId" )

  # ------------------------------------------------------------------
  # tests
  describe "instance '#{instance.value}'" do

    it "works" do 
      expect( 1 ).to eql( 1 )
    end

    describe ec2_resource( instance ) do
      its( :availability_zone  ) { should_not eq nil }
    end

    describe ec2_resource( instance ) do
      its( :system_status_ok?  ) { should eq true }
    end

    describe ec2_resource( instance ) do
      its( :instance_state_running?  ) { should eq true }
    end


  end


end

# +++fold-off+++
