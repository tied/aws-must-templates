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
      # return list of suite-roles (i.e. roles not in instances)
      def suite_roles( suite_id ) 
        suite = get_suite( suite_id )
        return (suite ? suite["roles"] : nil)
      end

      # ------------------------------------------------------------------
      # return list of suite-roles-ids (i.e. roles not in instances)
      def suite_role_ids( suite_id ) 
        roles = suite_roles( suite_id )
        return nil unless roles
        return roles.map{ |r| r.is_a?( Hash ) ? r.keys.first : r }
      end


      # ------------------------------------------------------------------
      # return list of instanceid for a suite
      def suite_instance_ids( suite_id ) 
        suite = get_suite( suite_id )
        return nil unless suite
        return suite["instances"] ? suite["instances"].map{ |instance_hash| instance_hash.keys.first } : []
      end

      # ------------------------------------------------------------------
      # currenty one suite means one to one stack
      alias_method :stack_ids, :suite_ids

      # return suite configuration for the suite id
      def get_suite( suite_id )
        suite = @suites.select { |suite| suite.keys.first == suite_id }.first
        return suite[suite_id] if suite 
        return nil
      end

      # return suite configuration for the suite id
      def get_suite_stack_id( suite_id )
        return suite_id
      end

      # return array of role_ids for 'instance_id' in 'suite_id'
      def suite_instance_role_ids( suite_id, instance_id )
        roles = suite_instance_roles( suite_id, instance_id )
        return roles unless roles
        return roles.map{ |r| r.is_a?( Hash ) ? r.keys.first : r }
      end

      # return roles  for 'instance_id' in 'suite_id'
      def suite_instance_roles( suite_id, instance_id )
        instance = suite_instance( suite_id, instance_id )
        return nil unless instance
        return [] unless instance[instance_id]
        return [] unless instance[instance_id]["roles"]
        # roles may be a hash or a string
        return instance[instance_id]["roles"]
      end


      # ------------------------------------------------------------------
      # return suite instance

      private

      # instance sub document for `instance_id` in `suite_id`
      def suite_instance( suite_id, instance_id )
        suite = get_suite( suite_id )
        return nil unless suite && suite["instances"]
        return suite["instances"].select { |i| i.keys.first == instance_id }.first
      end


      
    end # class TestSuites

  end # module TestSuites


end # module AwsMustTemplates

