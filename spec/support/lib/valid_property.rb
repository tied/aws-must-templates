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

      # key exist (may be nil)
      # RSpec document output 
      def to_s
        "property with keys #{@keys}" # + " in @runner.property= #{@runner.property}" 
      end

      # yield block for final value iterating 'keys' in 'props'
      def iterate_keys(keys, props )

        # iterate keys
        keys.each_with_index do |k,index| 
          # puts "Prrops=#{props}, k=#{k}"
          if  props.nil?  then
            # fixed point reached
            props = nil
          elsif props.is_a?( Hash ) then
            # recurse down a hash
            # props = props[k] 
            if index == (keys.size() -1 ) then
              props = yield props, k 
            else
              props = props[k] 
            end
          elsif props.is_a?( Array ) then
            # choose hash with a matching key from an array
            # props = props.select{ |e| e.is_a?(Hash) && e.keys.first == k }.first
            props = props.select{ |e| e.is_a?(Hash) && e.keys.include?(k) }.first
            if props then
              if index == (keys.size() -1) then
                props = yield props, k
              else
                props = props[k] 
              end
              # props = props[k] 
            end
          else
            # unknown case
            props = nil
          end
        end
        return props
      end

      # is last key defined (value maybe whatever)
      def defined?
        iterate_keys( @keys, @runner.property) { |hash,key|  hash.has_key?(key) }
      end

      # return value for 'keys' in '@runner.property'
      def resolve_value_for_keys( keys )
        iterate_keys( keys, @runner.property) { |hash,key|  hash[key] }
      end

    end

    # 
    def valid_property( keys )
      ValidProperty.new( keys)
    end
  end
end

include Serverspec::Type

