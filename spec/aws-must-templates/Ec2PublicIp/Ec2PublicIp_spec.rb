=begin

+++start+++

## <a id="Ec2PublicIp"></a>Ec2PublicIp<a class='navigator' href='#top'>[top]</a>

Validates that EC2 `InstanceId` `:public_ip_address` (none/defined/CidrBlock)

**Parameters**

* `instance = suite_value( :instance_name )` : name of instance being tested
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

  instance = suite_value( :instance_name )  # set in spec_help
  public_ip = test_parameter( current_test, "PublicIp" )


  # ------------------------------------------------------------------
  # tests
  describe "instance '#{instance.value}'" do


    describe "Public IP" do
    
      case public_ip.value

      when /\A(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\Z/ 
        describe ec2_named_resource_attribute( instance, "public_ip_address" ) do
          its( :public_ip_address  ) { should eql public_ip.value }
        end
      when "none", "nil"
        describe ec2_named_resource( instance ) do
          its( :public_ip_address  ) { should eql nil }
        end
      when "defined"
        describe ec2_named_resource( instance ) do
          its( :public_ip_address  ) { should_not  eql nil }
        end
      else
        raise "Invalid value '#{public_ip.value}' in parameter '#{public_ip}'"
      end # case
    end # public ip


  end # instance


end

# +++fold-off+++
