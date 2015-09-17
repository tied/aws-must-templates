=begin

+++start+++

## <a id="Stack"></a>Stack<a class='navigator' href='#top'>[top]</a>

Validate (and document in test report!) properties in
`property[:stack_id]`

+++close+++

=end

# +++fold-on+++

require 'spec_helper'


# @author jarjuk

# ------------------------------------------------------------------
# Configuration
# 

current_test = File.basename File.dirname  __FILE__ 

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
  "suite2" => [
             stack_parameter( "InstanceType" ),
             stack_parameter( "KeyName" ),
             stack_parameter( "SSHLocation" ),
             stack_output( "myFront1" ),
             stack_output( "myNat" ),
             stack_output( "InstanceId1" ),
             stack_output( "InstanceId2" ),
             stack_output( "MyInternetGw" ),
   ],
}
# ------------------------------------------------------------------
# 

describe current_test do 

  describe "Stack '#{property[:stack_id]}'", '#stack' do

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


# +++fold-off+++
