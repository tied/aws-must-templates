require 'spec_helper'

=begin

+++start+++

## <a id="AwsMustTestRunnerProperties"></a>AwsMustTestRunnerProperties<a class='navigator' href='#top'>[top]</a>

Validata that Test Runner works correctly and set properties

+++close+++

=end

# +++fold-on+++


# ------------------------------------------------------------------
# Configuration
# 

current_test = File.basename File.dirname  __FILE__ 

# every suite should define these paramentes
system_properties = [
                     [:stack_id ],
                     [:suite_id ],
                     ["Outputs" ],
                     ["Parameters" ],
                    ]

# ------------------------------------------------------------------
# 

describe current_test do 

  # ------------------------------------------------------------------
  # 
  describe "System properties" do

    system_properties.each do | keys |

      describe valid_property( keys ) do
        its( :value ) { should_not eq nil } 
      end

    end
  end


end

# +++fold-off+++

