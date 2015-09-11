=begin

+++start+++

## <a id="NetworkCanPing"></a>NetworkCanPing<a class='navigator' href='#top'>[top]</a>

Can ping to `test_parameter( current_test, "Destination" )`

+++close+++

=end

# +++fold-on+++
require 'spec_helper'

current_test = File.basename File.dirname  __FILE__ 

describe current_test do

  # defined in test-suites.yaml
  timeout = 20 # seconds
  testcount = 3 # times

  destination = test_parameter( current_test, "Destination" )


  describe "ping  #{testcount} times to '#{destination.value}', wait response within #{timeout} seconds" do
    cmd = "ping #{destination.value} -W #{timeout} -c #{testcount}"
    describe command( cmd ) do
      its(:exit_status) { should eq 0 }
    end
  end
end


# +++fold-off+++
