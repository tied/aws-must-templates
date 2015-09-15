=begin

+++start+++

## <a id="Ec2PublicIp"></a>Ec2PublicIp<a class='navigator' href='#top'>[top]</a>

Validates that EC2 `InstanceId` `:public_ip_address` (none/defined/CidrBlock)

**Parameters**

* `test_parameter( current_test, "InstanceId" )` 
* `test_parameter( current_test, "PublicIp" )` valid values
   * `nil` OR `none`  : should not be defined
   * V4 address public_ip_address belong to CidrBlock
   * `defined`: should not be nill

+++close+++

=end

# +++fold-on+++

require 'spec_helper'

current_test = File.basename File.dirname  __FILE__ 

describe current_test do

  # ------------------------------------------------------------------
  # test parameters

  instance = test_parameter( current_test, "InstanceId" )
  public_ip = test_parameter( current_test, "PublicIp" )
  # cidr_block = test_parameter( current_test, "CidrBlock" )


  # ------------------------------------------------------------------
  # tests
  describe "instance '#{instance.value}'" do


    describe "Public IP" do
    
      case public_ip.value

      when /\A(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\Z/ 
        describe ec2_resource_attribute( instance, "public_ip_address" ) do
          its( :public_ip_address  ) { should eql public_ip.value }
        end
      when "none", "nil"
        describe ec2_resource( instance ) do
          its( :public_ip_address  ) { should eql nil }
        end
      when "defined"
        describe ec2_resource( instance ) do
          its( :public_ip_address  ) { should_not  eql nil }
        end
      else
        raise "Invalid value '#{public_ip.value}' in parameter '#{public_ip}'"
      end # case
    end # public ip

    # # validate CidrBlock
    # if !cidr_block.value.empty? && cidr_block.value != "none" then

    #   describe "CidrBlock" do
    #     describe ec2_resource_attribute( instance, "public_ip_address" ) do
    #       it "#valid cidr #{cidr_block.value}" do
    #         expect( subject.cidr_valid_ip(  subject.public_ip_address, cidr_block.value ) ).to eql( true )
    #       end
    #     end
    #   end
    # end # if validate CidrBlock

  end # instance


end

# +++fold-off+++
