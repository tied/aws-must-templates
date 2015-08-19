
module Serverspec
  module Type
     
    class ValidProperty < Base
  
      def initialize(props,keys)
        keys.each do |k| 
          props = props[k]
        end
        @value = props
        @keys  = keys
      end
     
      def value
        @value
      end

      # returns the DNS server as a string in the form '192.168.1.1 [Master]'
      def to_s
        "property with keys #{@keys}"
      end

    end

    def valid_property(props, keys)
      ValidProperty.new(props, keys)
    end
  end
end

include Serverspec::Type

