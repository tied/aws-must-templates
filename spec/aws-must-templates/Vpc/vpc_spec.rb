=begin

+++start+++

## <a id="Vpc"></a>Vpc<a class='navigator' href='#top'>[top]</a>

Validates that Vpc tagged with `Name` = `test_parameter( current_test, "VpcName" )`
exists, and that it is available.


**Parameters**

* `test_parameter( current_test, "VpcName" )` : search for Vpc with 'Name' tag


+++close+++

=end

# +++fold-on+++

require 'spec_helper'

current_test = File.basename File.dirname  __FILE__ 

describe current_test do

  # ------------------------------------------------------------------
  # test parameters

  vpcName = test_parameter( current_test, "VpcName" )


  # ------------------------------------------------------------------
  # tests
  describe "vpc '#{vpcName.value}'" do

    describe vpc_resource_by_name( vpcName.value ) do

      it "#is available Vpc" do
        expect( subject.is_available?).to eql( true )
      end

    end

  end # instance


end

# +++fold-off+++
