=begin

+++start+++

## <a id="RespondsToPing"></a>RespondsToPing<a class='navigator' href='#top'>[top]</a>

Validate that host  `test_parameter( current_test, "Hostname" )`  answers to ping

+++close+++

=end

# +++fold-on+++

require 'spec_helper'

current_test = File.basename File.dirname  __FILE__ 

describe current_test do

  # ------------------------------------------------------------------
  # test parameters

  hostname = test_parameter( current_test, "Hostname" )
  timeout = 20 # seconds
  testcount = 3 # times

  # ------------------------------------------------------------------
  # tests

  describe "ping '#{hostname.value}'" do

    it "#reponds within #{timeout} seconds with #{testcount} test counts" do 
      # -W:  Time to wait for a response, in seconds
      # -c:  Stop after sending count ECHO_REQUEST packets. With deadline
      # -option, ping waits for count ECHO_REPLY packets, until the
      # -timeout expires

      cmd = "ping #{hostname.value} -W 20 -c 3"
      # puts cmd `#{cmd}` 
      raise "Error in '#{cmd}' " unless $? == 0 end
  end

end

# +++fold-off+++
