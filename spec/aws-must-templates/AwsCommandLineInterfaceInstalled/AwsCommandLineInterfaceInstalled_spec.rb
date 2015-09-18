=begin

+++start+++

## <a id="AwsCommandLineInterfaceInstalled"></a>AwsCommandLineInterfaceInstalled<a class='navigator' href='#top'>[top]</a>

Validate that command `aws` is installed.

+++close+++

=end

# +++fold-on+++

require  'spec_helper'

current_test = File.basename File.dirname  __FILE__ 

describe current_test do

  describe command('type aws') do
      its( :exit_status ) { should eq 0 }
  end


end

# +++fold-off+++
