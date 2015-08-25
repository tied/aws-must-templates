#
# Validate a value statck output in property -hash
#

module Serverspec
  module Type

    class StackOutput < ValidProperty

      def initialize(output)
        keys = ["Outputs"]
        keys << output
        @output = output
        super( keys )
      end

      def to_s
        "Stack output '#{@output}'" # + " in @runner.property= #{@runner.property}" 
      end

    end # class

    def stack_output( output )
      StackOutput.new( output )
    end

  end
end

include Serverspec::Type

