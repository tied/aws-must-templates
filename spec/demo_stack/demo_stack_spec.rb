require 'spec_helper'


# ------------------------------------------------------------------
# validate stack parameters 

expected_properties = [
 [:host ],
 ["Outputs", property[:host]],
 ["Parameters", "InstanceType" ],
 ["Parameters", "KeyName" ],
 ["Parameters", "SSHLocation" ],
 ["Parameters", "BucketName" ],
]

describe "Ensure that cloudformation stack parameters && outputs define mandatory value" do 

  expected_properties.each do | propArra |
    it "Property #{propArra} must not be nil" do
      props = property
      propArra.each do |k|
        expect( props[k] ).not_to eql nil
        props = props[k]
      end
    end

  end

end

