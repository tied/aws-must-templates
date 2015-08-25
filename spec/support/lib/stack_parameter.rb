#
# Validate a value statck output in property -hash
#

module Serverspec
  module Type

    class StackParameter < ValidProperty

      def initialize(parameter)
        keys = ["Parameters"]
        keys << parameter
        @parameter = parameter
        super( keys)
      end

      def to_s
        "Stack parameter '#{@parameter}'" # + " in @runner.property= #{@runner.property}" 
      end

    end # class


    def stack_parameter( parameter )
      StackParameter.new( parameter )
    end

  end
end

include Serverspec::Type

