module Serverspec
  module Type

    class SuiteValue < ValidProperty

      VALID_VALUES = [  :host, 
                        :instance_name, 
                        :stack_id,
                        :suite_id
                     ]

      def initialize(key)
        raise <<-EOS  unless VALID_VALUES.include?(key)
          Invalid suite value #{key}

          Valid values #{VALID_VALUES.join( ', ')}
        EOS
        keys = []
        keys << key
        @key = key
        super( keys )
      end

      def to_s
        "Suite value '#{@key}'"
      end

    end # class

    def suite_value( key )
      SuiteValue.new( key )
    end

  end
end

include Serverspec::Type

