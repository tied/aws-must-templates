#
# Validate a value of property with a path `keys` in `props` hash
#

module Serverspec
  module Type
     
    class ValidProperty < Base
  
      def initialize( keys )
        @value = resolve_value_for_keys( keys )
        @keys  = keys
      end

      # Return value of the property
      def value
        @value
      end

      # RSpec document output 
      def to_s
        "property with keys #{@keys}" # + " in @runner.property= #{@runner.property}" 
      end

      # return value for '@runner.property'
      def resolve_value_for_keys( keys )

        props = @runner.property

        # iterate keys
        keys.each do |k| 
          # puts "Prrops=#{props}, k=#{k}"
          if  props.nil?  then
            # fixed point reached
            props = nil
          elsif props.is_a?( Hash ) then
            # recurse down a hash
            props = props[k] 
          elsif props.is_a?( Array ) then
            # choose hash with a matching key from an array
            props = props.select{ |e| e.is_a?(Hash) && e.keys.first == k }.first
            props = props[k] if props
          else
            # unknown case
            props = nil
          end
        end
        
        return props

      end

    end

    # 
    def valid_property( keys )
      ValidProperty.new( keys)
    end
  end
end

include Serverspec::Type

