require 'spec_helper'



# ------------------------------------------------------------------
# Configuration
# 

current_test = "Stack"

props = {
  "smoke" => [
             stack_parameter( "DummyParameter" ),
             stack_output( "Bucket" ),
             stack_output( "BucketName" ),
             ],
  "suite1" => [
             stack_output( "Bucket" ),
             stack_parameter( "InstanceType" ),
             stack_parameter( "KeyName" ),
             stack_parameter( "SSHLocation" )
   ],
}
# ------------------------------------------------------------------
# 

describe current_test do 

  describe "Stack '#{property[:stack_id]}'" do

    it "#known in test '#{current_test}''" do 

      expect( props[property[:stack_id]]).not_to eql( nil ) 

    end

    # Validate configurations

    props[property[:stack_id]] && props[property[:stack_id]].each do | stack_property |
      describe stack_property  do
        its( :value ) { should_not eq nil } 
      end
    end

  end

end

