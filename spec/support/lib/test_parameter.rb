module Serverspec
  module Type

    class TestParameter < ValidProperty

      def initialize( role_id, test_parameter_name, mandatory )

        keys = ["Roles"]
        keys << role_id
        keys << test_parameter_name

        @role_id = role_id
        @test_parameter_name = test_parameter_name

       super( keys )

        validate if mandatory

      end

      # rpsec description text
      def to_s
        "Test parameter '#{@test_parameter_name}' for role '#{@role_id}'"
      end

      # error string
      def to_error_s
        "Test paramater '#{@test_parameter_name}' configuration error in suite '#{ @runner.property[:suite_id]}' #{ @runner.property[:instance_id] ? 'instance \'' +  @runner.property[:instance_id] + '\'' : ' common ' } test '#{@role_id}' "
      end

      # definition in test_suite.yaml (nil if not defined)
      def definition_in_test_suite
        self.class.superclass.instance_method(:value).bind(self).call
        # method( :value ).super_method.call
      end

      # exception unless definition ok
      def validate
        raise to_error_s unless definition_in_test_suite
      end

      # evaluated value
      def value
        val = super
        return param_evaluate( val )
      end

      private 

      # value starts with '@' --> lookup in 'properties'
      def param_evaluate( val )
        return val if val.nil? 
        return val unless val[0] == "@"
        return resolve_value_for_keys( val[1..-1].split( '.' ) )
      end

    end # class

    def test_parameter( role_id, test_parameter_name, mandatory=true )
      TestParameter.new( role_id, test_parameter_name, mandatory )
    end

  end
end

include Serverspec::Type

