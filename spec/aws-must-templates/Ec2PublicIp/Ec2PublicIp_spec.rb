=begin

+++start+++

## <a id="Ec2PublicIp"></a>Ec2PublicIp<a class='navigator' href='#top'>[top]</a>

Validates that EC2 `InstanceId` has a public ip associated

* `:public_ip_address` == `PublicIp` 

**Parameters**

* `test_parameter( current_test, "InstanceId" )` 
* `test_parameter( current_test, "PublicIp" )` valid values
   * `nil`  : should not be defined
   * `none`: should not be defined (=alias nil)
   * V4 address regexp: should eql 
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

  # ------------------------------------------------------------------
  # tests
  describe "instance '#{instance.value}'" do


    describe "Public IP" do
    
      case public_ip.value
      when /\A(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\Z/ 
        describe ec2_resource( instance ) do
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
  end # instance


end

# +++fold-off+++
