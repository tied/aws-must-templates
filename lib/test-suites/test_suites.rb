require 'yaml'

module AwsMustTemplates

  module TestSuites

    # ------------------------------------------------------------------
    # Constants
    SUITE_CONFIGS = 'test-suites.yaml'    # YAML configuration file for suites/instances

    # ------------------------------------------------------------------
    # class

    class TestSuites

      # ------------------------------------------------------------------
      # constructor loads YAML configuration, raise expcetion if not found
      def initialize( )
        yaml_file = SUITE_CONFIGS

        raise <<-EOS unless File.exist?( yaml_file )

          No such file '#{yaml_file}'

          Could not load test-suites configuration file.

        EOS

        @suites = YAML.load_file( yaml_file ) || []
      end

      # ------------------------------------------------------------------
      # return list of suite-ids
      def suite_ids
        return @suites.map{ |suite| suite.keys.first }
      end

      # ------------------------------------------------------------------
      # currenty one suite means one to one stack
      alias_method :stack_ids, :suite_ids

      # return suite configuration for the suite id
      def get_suite( suite_id )
        return @suites.select { |suite| suite.keys.first == suite_id }.first
      end
      

      
    end # class TestSuites

  end # module TestSuites


end # module AwsMustTemplates

