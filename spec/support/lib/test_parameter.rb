module Serverspec
  module Type

    class TestParameter < ValidProperty

      def initialize(output)
        keys = ["Outputs"]
        keys << output
        @output = output
        super( @runner.property, keys)
      end

      def to_s
        "Stack output '#{@output}'" # + " in @runner.property= #{@runner.property}" 
      end

    end # class

    def test_parameter( name )
      TestParameter.new( output )
    end

  end
end

include Serverspec::Type

