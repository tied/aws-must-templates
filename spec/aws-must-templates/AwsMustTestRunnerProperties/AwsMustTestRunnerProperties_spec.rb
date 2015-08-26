require 'spec_helper'



# ------------------------------------------------------------------
# Configuration
# 

current_test = "AwsMustTestRunnerProperties"

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

