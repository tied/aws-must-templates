require 'spec_helper'


# ------------------------------------------------------------------
# validate stack property values
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

describe "Stack properties" do 

  common_properties.each do | propArra |

    it "Property #{propArra} must not be nil" do
      props = property
      propArra.each do |k|
        expect( props[k] ).not_to eql nil
        props = props[k]
      end
    end

  end


  it "Stack '#{property[:stack]}' is  known in '#{__FILE__}'" do
    expect( suite_properties[property[:stack]] ).not_to eql nil
  end


  context "Stack '#{property[:stack]}' defines value for" do

    before [:all] do
      @suite_properties = suite_properties[property[:stack]]
    end
    suite_properties[property[:stack]].each do | propArra |

        it "#{propArra}" do

          props = property
          propArra.each do |k|
            expect( props[k] ).not_to eql nil
            props = props[k]
        end
      end

    end if suite_properties[property[:stack]]

  end # context stack 

end
