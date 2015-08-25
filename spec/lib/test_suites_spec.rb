require_relative "spec_helper.rb"

require 'yaml'

describe "AwsMustTemplates::TestSuites::TestSuites" do

  # ------------------------------------------------------------------
  # default test case

  before :each do

    @suite1 = {
       "suite1" => {
         "desc" => "suite 1 test"
      }
    }
    
    @suite3_roles = [ "commonrole1", { "commonrole2" => {} }]
    @suite3_instance2_roles = [ { "role1" => {}}, "role2", "role3" ]
    @suite3 = {
       "suite3" => {
         "desc" => "suite 3 test",
         "roles" => @suite3_roles,
         "instances" => [
               { "instance1" => {}}, 
               {"instance2" => {
                             "roles" => @suite3_instance2_roles
                            }},
           ]
      }
    }
    suites = [@suite1, @suite3]

    yaml_text = suites.to_yaml
    
    # puts "yaml_text=\n#{yaml_text}"
    @default_yaml = stub_yaml_file( yaml_text )
    
    @sut = AwsMustTemplates::TestSuites::TestSuites.new
  end

  # ------------------------------------------------------------------
  # interface

  describe "interface" do
    
    it "method 'suite_ids'" do
      expect( @sut ).to respond_to( :suite_ids )
    end

    it "method 'stack_ids'" do
      expect( @sut ).to respond_to( :stack_ids )
    end


    it "methods 'get_suite'" do
      expect( @sut ).to respond_to( :get_suite )
    end

    it "methods 'get_suite_stack_id'" do
      expect( @sut ).to respond_to( :get_suite_stack_id )
    end

    it "methods 'suite_roles'" do
      expect( @sut ).to respond_to( :suite_roles )
    end

    it "methods 'suite_role_ids'" do
      expect( @sut ).to respond_to( :suite_role_ids )
    end

    it "methods 'suite_instance_ids'" do
      expect( @sut ).to respond_to( :suite_instance_ids )
    end

    it "methods 'suite_instance_role_ids'" do
      expect( @sut ).to respond_to( :suite_instance_role_ids )
    end

    it "methods 'suite_instance_roles'" do
      expect( @sut ).to respond_to( :suite_instance_roles )
    end


  end # describe "interface" do

  # ------------------------------------------------------------------
  # suite_instance_roles
  describe "suite_instance_roles" do

    it "#nil - when suite not found" do
      suite_id = "aaa"
      instance_id =  "notsucnhcid"
      expect( @sut.suite_instance_roles( suite_id, instance_id )).to eql( nil )
    end

    it "#nil - when instance not not found" do
      suite_id = @suite1.keys.first
      instance_id =  "notsucnhcid"
      expect( @sut.suite_instance_roles( suite_id, instance_id )).to eql( nil )
    end

    it "#empty array - when no roles defined" do
      suite_id = @suite3.keys.first
      instance_id =  @suite3[suite_id]["instances"][0].keys.first
      expect( @sut.suite_instance_roles( suite_id, instance_id )).to eql( [] )
    end

    it "#array of role defs - normal case" do
      suite_id = @suite3.keys.first
      instance_id =  @suite3[suite_id]["instances"][1].keys.first
      roles_ids =  ["role1", "role2", "role3" ]
      expect( @sut.suite_instance_roles( suite_id, instance_id )).to eql( @suite3_instance2_roles )
    end



  end


  # ------------------------------------------------------------------
  # suite_instance_role_ids
  describe "suite_instance_role_ids" do

    it "#nil - when suite not found" do
      suite_id = "aaa"
      instance_id =  "notsucnhcid"
      expect( @sut.suite_instance_role_ids( suite_id, instance_id )).to eql( nil )
    end

    it "#nil - when insance not not found" do
      suite_id = @suite1.keys.first
      instance_id =  "notsucnhcid"
      expect( @sut.suite_instance_role_ids( suite_id, instance_id )).to eql( nil )
    end

    it "#empty array - when no roles defined" do
      suite_id = @suite3.keys.first
      instance_id =  @suite3[suite_id]["instances"][0].keys.first
      expect( @sut.suite_instance_role_ids( suite_id, instance_id )).to eql( [] )
    end

    it "#array of role ids - normal case" do
      suite_id = @suite3.keys.first
      instance_id =  @suite3[suite_id]["instances"][1].keys.first
      roles_ids =  ["role1", "role2", "role3" ]
      expect( @sut.suite_instance_role_ids( suite_id, instance_id )).to eql( roles_ids )
    end

  end

  # ------------------------------------------------------------------
  # suite_instance_ids
  describe "suite_instance_ids" do

    it "#nil - when suite not found" do
      suite_id = "aaa"
      expect( @sut.suite_instance_ids( suite_id )).to eql( nil )
    end

    it "#empty array - when suite does not have any instances" do
      suite_id = @suite1.keys.first
      expect( @sut.suite_instance_ids( suite_id )).to eql( [] )
    end

    it "#array of instance_id - normal case" do
      suite_id = @suite3.keys.first
      expect( @sut.suite_instance_ids( suite_id )).to eql( @suite3.values.first["instances"].map { |h| h.keys.first })
    end

  end

  # ------------------------------------------------------------------
  # suite_ids

  describe "get_suite_stack_id" do

    it "#currenty returns suite_id as stack_id" do
      suite_id = "aaa"
      expect( @sut.get_suite_stack_id( suite_id )).to eql( suite_id )
    end

  end

  # ------------------------------------------------------------------
  # suite_roles

  describe "suite_roles" do

    it "#nil when suite not found" do
      suite_id = "aaa"
      expect( @sut.suite_roles( suite_id )).to eql( nil )
    end

    it "#nil when no roles for suite" do
      suite_id = @suite1.keys.first
      # suite found
      expect( @sut.get_suite( suite_id )).not_to eql( nil )
      # but no roles for the suite
      expect( @sut.suite_roles( suite_id )).to eql( nil )
    end

    it "#arrays of roles when no roles for suite" do
      suite_id = @suite3.keys.first
      expected_roles  = @suite3[suite_id]["roles"]
      expect( @sut.suite_roles( suite_id )).to eql( expected_roles )
    end



  end

  # ------------------------------------------------------------------
  # suite_role_ids

  describe "suite_role_ids" do

    it "#nil when suite not found" do
      suite_id = "aaa"
      expect( @sut.suite_role_ids( suite_id )).to eql( nil )
    end

    it "#nil when no roles for suite" do
      suite_id = @suite1.keys.first
      # suite found
      expect( @sut.get_suite( suite_id )).not_to eql( nil )
      # but no roles for the suite
      expect( @sut.suite_role_ids( suite_id )).to eql( nil )
    end

    it "#arrays of ids - normal case" do
      suite_id = @suite3.keys.first
      expected_roles  = @suite3[suite_id]["roles"]
      expect( @sut.suite_roles( suite_id )).to eql( expected_roles )
    end

  end

  # ------------------------------------------------------------------
  # suite_ids

  describe "get_suite" do

    suite_id = "suite1"

    it "#returns suite when found" do
      expect( @sut.get_suite( suite_id )).to eql( @suite1 )
    end

    it "#returns nil when NOT found" do
      expect( @sut.get_suite( suite_id+'x' )).to eql( nil )
    end


  end # describe "get_suite" do

  # ------------------------------------------------------------------
  # suite_ids

  describe "stack_ids" do

    it "#currently returns  suite ids as stack is" do
      expect( @sut.stack_ids ).to eql( [@suite1.keys.first, @suite3.keys.first] )
    end


  end # describe "get_suite" do




  # ------------------------------------------------------------------
  # suite_ids

  describe "suite_ids" do

    before :each do
      yaml_text = <<-EOF
         # suitelist return suite keys
         - suite1:
         - suite2:
      EOF
      stub_yaml_file( yaml_text )
      @sut = AwsMustTemplates::TestSuites::TestSuites.new
    end

    it "#returns an Array" do
      expect( @sut.suite_ids.kind_of?( Array )).to eql( true )
    end

    it "#returns all suites" do
      expect( @sut.suite_ids.size ).to eql( 2 )
    end

    it "#returns all suites" do
      expect( @sut.suite_ids ).to eql( ["suite1", "suite2"] )
    end

    
  end


  # ------------------------------------------------------------------
  # constructore

  describe "constructor" do

    it "#loads YAML from default location" do
      expect( YAML ).to receive(:load_file).with(AwsMustTemplates::TestSuites::SUITE_CONFIGS).and_return("yaml_content")
      AwsMustTemplates::TestSuites::TestSuites.new
    end 

    it "#expception when YAML configuration file not found" do
      yaml_file = AwsMustTemplates::TestSuites::SUITE_CONFIGS
      expect( File ).to receive( :exist? ).with(yaml_file).and_return( false )
      expect { AwsMustTemplates::TestSuites::TestSuites.new }.to raise_error( /No such file/ )
    end 

  end
  

  it "#works" do
    expect( 1 ).to eql( 1 )
  end 

  # ------------------------------------------------------------------
  # helpers
  def stub_yaml_file( yaml_text  )

    yaml = YAML.load(yaml_text)

    yaml_file = AwsMustTemplates::TestSuites::SUITE_CONFIGS

    expect( YAML ).to receive(:load_file).with(yaml_file).and_return( yaml ) 
    allow( File ).to receive( :exist? ).with(yaml_file).and_return( true )

    return yaml_file
    
  end


end

