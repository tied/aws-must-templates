=begin

+++start+++

## <a id="Ec2PrivateIp"></a>Ec2PrivateIp<a class='navigator' href='#top'>[top]</a>

Validates EC2 `InstanceId` public ip 'private_ip_address' is with
`CidrBlock`

**Parameters**

* `instance = suite_value( :instance_id )` : name of instance being tested
* `test_parameter( current_test, "CidrBlock" )` : mandatory, should be valid Cidr

+++close+++

=end

# +++fold-on+++

require 'spec_helper'

current_test = File.basename File.dirname  __FILE__ 

describe current_test do

  # ------------------------------------------------------------------
  # test parameters

  instance = suite_value( :instance_id )  # set in spec_helper
  cidr_block = test_parameter( current_test, "CidrBlock" )

  # ------------------------------------------------------------------
  # tests
  describe "instance '#{instance.value}'" do

    describe ec2_named_resource_attribute( instance, "private_ip_address" ) do

      it "#valid cidr #{cidr_block.value}" do
        expect( subject.private_ip_address_valid_cidr?( cidr_block.value ) ).to eql( true )
      end
    end

  end # instance


end

# +++fold-off+++
