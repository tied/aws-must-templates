=begin

+++start+++

## <a id="ValidOSVersion"></a>ValidOSVersion<a class='navigator' href='#top'>[top]</a>

Validate that operating system codename == `test_parameter( current_test, "Codename" )`

+++close+++

=end

# +++fold-on+++
require 'spec_helper'

current_test = File.basename File.dirname  __FILE__ 

describe current_test do

  # defined in test-suites.yaml
  codename = test_parameter( current_test, "Codename" )

  describe "Operating system codename '#{codename.value}'" do
    describe command('lsb_release --c -s') do
      its( :stdout ) { should match /#{codename.value}/ }
    end
  end
end


# +++fold-off+++
