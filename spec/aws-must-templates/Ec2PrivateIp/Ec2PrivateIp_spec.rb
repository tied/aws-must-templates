=begin

+++start+++

## <a id="Ec2PrivateIp"></a>Ec2PrivateIp<a class='navigator' href='#top'>[top]</a>

Validates EC2 `InstanceId` public ip `:public_ip_address` using
test paramter `CidrBlock`

**Parameters**

* `test_parameter( current_test, "InstanceId" )` : mandatory
* `test_parameter( current_test, "CidrBlock" )` : mandatory, should be valid Cidr

+++close+++

=end

# +++fold-on+++

require 'spec_helper'

current_test = File.basename File.dirname  __FILE__ 

describe current_test do

  # ------------------------------------------------------------------
  # test parameters

  instance = test_parameter( current_test, "InstanceId" )
  cidr_block = test_parameter( current_test, "CidrBlock" )

  # ------------------------------------------------------------------
  # tests
  describe "instance '#{instance.value}'" do

    describe ec2_resource_attribute( instance, "private_ip_address" ) do
      it { should_not eql nil }

      it "#valid cidr #{cidr_block.value}" do
        expect( subject.private_ip_address_valid_cidr?( cidr_block.value ) ).to eql( true )
      end
    end

  end # instance


end

# +++fold-off+++
