=begin

+++start+++

## <a id="ParameterTest"></a>ParameterTest<a class='navigator' href='#top'>[top]</a>

Demonstrate a test accessing `test_parameters`

+++close+++

=end

# +++fold-on+++

require 'spec_helper'


current_test = "ParameterTest"

describe  current_test do |ex|


  # ------------------------------------------------------------------
  # test parameters
  parameter1 = test_parameter( current_test, "param1" )
  parameter2 = test_parameter( current_test, "param2" )
  parameter3 = test_parameter( current_test, "param3" )


  # ------------------------------------------------------------------
  # Test paramters defined

  describe "Test parameter definition" do

    describe parameter1 do
      its( :definition_in_test_suite ) { should_not  eq nil }
    end

    describe parameter2 do
      its( :definition_in_test_suite ) { should_not eq nil }
    end

    describe parameter3 do
      its( :definition_in_test_suite ) { should_not eq nil }
    end

  end #  describe "Test parameters" do

end

# +++fold-off+++
