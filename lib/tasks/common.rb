module AwsMustTemplates
  module Common

    # ------------------------------------------------------------------
    # rquires

    require 'yaml'

    # ------------------------------------------------------------------
    # Config - as module params

    @@suite_configs     = 'test-suites.yaml'    # YAML configuration file for suites/instances            


    # ------------------------------------------------------------------
    # Init

    def self.init_suites
      suite_properties = YAML.load_file( @@suite_configs ) || []
    end

    def self.init_stacks( suite_properties )
      stacks = Rake::FileList.new( suite_properties.map { |s| s.keys.first + '.yaml'} ) 
    end


  end
end
