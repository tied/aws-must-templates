#
# Validate a value of property with a path `keys` in `props` hash
#

module Serverspec
  module Type
     
    class ValidProperty < Base
  
      def initialize(props,keys)
        keys.each do |k| 
          props = props[k] if props
        end
        @value = props
        @keys  = keys
      end

      # Return value of the property
      def value
        @value
      end

      # RSpec document output 
      def to_s
        "property with keys #{@keys}"
      end

    end

    # 
    def valid_property( props, keys )
      ValidProperty.new(props, keys)
    end
  end
end

include Serverspec::Type

