=begin

+++start+++

## <a id="RespondsToPing"></a>RespondsToPing<a class='navigator' href='#top'>[top]</a>

Validate that instance answers to ping.

+++close+++

=end

# +++fold-on+++

require 'spec_helper'

current_test = File.basename File.dirname  __FILE__ 

describe current_test do

  # ------------------------------------------------------------------
  # test parameters

  instance = suite_value( :instance_name )

  timeout = 20 # seconds
  testcount = 3 # times

  # ------------------------------------------------------------------
  # tests

  describe "ping '#{instance.value}'" do

    describe ec2_named_resource(instance.value) do

      let( :public_dns_name ) { subject.public_dns_name }
      its( :public_dns_name ) { should_not eql nil }


      it "#reponds within #{timeout} seconds with #{testcount} test counts" do 
        # -W:  Time to wait for a response, in seconds
        # -c:  Stop after sending count ECHO_REQUEST packets. With deadline
        # -option, ping waits for count ECHO_REPLY packets, until the
        # -timeout expires

        cmd = "ping #{public_dns_name} -W 20 -c 3"
        # puts cmd `#{cmd}` 
        raise "Error in '#{cmd}' " unless $? == 0 end
    end
  end

end

# +++fold-off+++
