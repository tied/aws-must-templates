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
    @suite3 = {
       "suite3" => {
         "desc" => "suite 1 test"
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


  end # describe "interface" do



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

