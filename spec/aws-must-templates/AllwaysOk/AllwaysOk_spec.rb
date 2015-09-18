=begin

+++start+++

## <a id="AllwaysOk"></a>AllwaysOk<a class='navigator' href='#top'>[top]</a>

Make at least one test succeed.

+++close+++

=end

# +++fold-on+++

require 'spec_helper'


current_test = File.basename File.dirname  __FILE__ 

describe  current_test do 


  # ------------------------------------------------------------------
  # Test paramters defined

  describe "Success" do

    it "#works" do
      expect( 1 ).to eql( 1 )
    end
  end
    
end

# +++fold-off+++
