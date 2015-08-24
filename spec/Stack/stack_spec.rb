require 'spec_helper'


# ------------------------------------------------------------------
# Configuration
# 


# every suite should define these paramentes
common_properties = [
                     [:stack ],
                     ["Outputs" ],
                     ["Parameters" ],
                    ]

# each suite should configured here
suite_properties = {

  "suite1" => [
             [:host ],
             ["Outputs", property[:host]],
             ["Outputs", "Bucket" ],
             ["Parameters", "InstanceType" ],
             ["Parameters", "KeyName" ],
             ["Parameters", "SSHLocation" ],
            ],

  "smoke" => [
             ["Outputs", "Bucket"],
             ["Outputs", "BucketName"],
            ],

}

# ------------------------------------------------------------------
# 

describe "Stack" do 

  # ------------------------------------------------------------------
  #


  it "Stack '#{property[:stack]}' defined in 'property[:stack]'" do
    expect( suite_properties[property[:stack]] ).not_to eql nil
  end

  # ------------------------------------------------------------------
  # 
  describe "Mandatory properties for all stacks" do

    common_properties.each do | keys |

      describe valid_property( property, keys ) do
        its( :value ) { should_not eq nil } 
      end

    end
  end


  # ------------------------------------------------------------------
  # 
  describe "Stack '#{property[:stack]}'" do

    puts "property=#{property}"

    describe "should be well known" do

      it "#can be found in 'suite_properties'" do 

        expect( suite_properties[property[:stack]]).not_to   eql( nil ) 

      end

    end

    suite_properties[property[:stack]] && suite_properties[property[:stack]].each do | keys |

      describe valid_property( property, keys ) do
        its( :value ) { should_not eq nil } 
      end
      
    end
  end

end

