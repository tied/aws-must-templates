require 'spec_helper'


# ------------------------------------------------------------------
# validate stack parameters 

common_properties = [
                     [:host ],
                     [:stack ],
                    ]

suite_properties = {

  "suite1" => [
             ["Outputs", property[:host]],
             ["Parameters", "InstanceType" ],
             ["Parameters", "KeyName" ],
             ["Parameters", "SSHLocation" ],
             ["Parameters", "BucketName" ],
            ]
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