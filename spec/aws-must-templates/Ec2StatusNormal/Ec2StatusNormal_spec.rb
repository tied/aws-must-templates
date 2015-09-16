=begin

+++start+++

## <a id="Ec2StatusNormal"></a>Ec2StatusNormal<a class='navigator' href='#top'>[top]</a>

Validates that status of `InstanceId` EC2  status for `describe_instance_status` normal:

* defefines `:availability_zone`
* `:system_status_ok?`
* `:instance_state_running?`

**Parameters**

* `instance = suite_value( :instance_id )` : name of instance being tested


+++close+++

=end

# +++fold-on+++

require 'spec_helper'

current_test = File.basename File.dirname  __FILE__ 

describe current_test do

  # ------------------------------------------------------------------
  # test parameters

  instanceName = suite_value( :instance_id )

  expected = [
              { :prop => :system_status_not_impaired?, :expect => true },
              { :prop => :instance_state_running?, :expect => true  } 
             ]

  # ------------------------------------------------------------------
  # tests

  describe "instanceName '#{instanceName.value}'" do

    expected.each do |prop|
      describe ec2_named_resource( instanceName ) do
        its( prop[:prop] ) { should eq prop[:expect] }
      end
    end

  end # describe instanceId

end

# +++fold-off+++
