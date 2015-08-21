require_relative "spec_helper"

template_under_test = "root"

describe template_under_test do

  let( :template_dir ) { "mustache" }
  let( :template_file_path ) { ->(x) { "#{template_dir}/#{x}.mustache" } }


  before :each do 
    @aws_must = AwsMust::AwsMust.new( { :template_path => template_dir } )

    # hide partials
    allow_any_instance_of( AwsMust::Template ).to receive( :partial ).with( any_args ).and_return( "" )

    # verify that template_under_test actually used
    expect_any_instance_of( AwsMust::Template ).to receive( :get_template ).with( template_under_test  ).and_call_original
  end


  it "#empty YAML'" do

    allow( File ).to receive( :read ).with( any_args ).and_call_original

    expect_str = <<-EOS
    {"AWSTemplateFormatVersion":"2010-09-09", "Description":"", "Parameters":{}, "Mappings": {},  "Resources":{}, "Outputs":{}}
    EOS

    yaml_text = <<-EOF
      EOF
    expect( json_sanitize( @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} ) )).to eql( json_sanitize( expect_str ))


  end

  describe "Parameters" do

    it "#parameters" do


      stubbed_template = ['"aa":1,', '"bb": 2']

      expect_str = <<-EOS
    {"AWSTemplateFormatVersion":"2010-09-09", "Description":"", "Parameters":{ #{stubbed_template.join} }, "Mappings": {},  "Resources":{}, "Outputs":{}}
    EOS

      yaml_text = <<-EOF
      parameters:
         - key1: value1
         - key2: value2
      EOF


      expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :parameter ).and_return( *stubbed_template )


      expect( json_sanitize( @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} ) )).to eql( json_sanitize( expect_str ))


    end

  end # desc

  
  describe "Mappings -section" do

    it "#mappings" do


      stubbed_template = ['"mapo":1' ]
      
      expect_str = <<-EOS
    {"AWSTemplateFormatVersion":"2010-09-09", "Description":"", "Parameters":{  }, "Mappings": { #{stubbed_template.join} },  "Resources":{}, "Outputs":{}}
    EOS

      yaml_text = <<-EOF
      EOF


      expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :mappings ).and_return( *stubbed_template )


      expect( json_sanitize( @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} ) )).to eql( json_sanitize( expect_str ))


    end

    it "#mapping" do


      stubbed_template1 = [ '"aaa":0' ]
      stubbed_template2 = ['"bbb":1,',  '"ccc": 2' ]

      expect_str = <<-EOS
    {"AWSTemplateFormatVersion":"2010-09-09", "Description":"", "Parameters":{}, "Mappings": {  #{stubbed_template1.join}, #{stubbed_template2.join} },  "Resources":{}, "Outputs":{}}
    EOS

      # 

      yaml_text = <<-EOF
      mappings:
          - yksi
          - kaksi
      EOF

      expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :mappings ).once.and_return( *stubbed_template1 )
      expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :mapping ).twice.and_return(  *stubbed_template2  )

      expect( json_sanitize( @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} ) )).to eql( json_sanitize( expect_str ))


    end



  end

  # ------------------------------------------------------------------
  # 
  describe "Resources -section" do

    it "#resources" do

      stubbed_template = ['"resu1":1' ]
      
      expect_str = <<-EOS
    {"AWSTemplateFormatVersion":"2010-09-09", "Description":"", "Parameters":{  }, "Mappings": { },  "Resources":{  #{stubbed_template.join} }, "Outputs":{}}
    EOS

      yaml_text = <<-EOF
      EOF

      expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :resources ).once.and_return( *stubbed_template )

      expect( json_sanitize( @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} ) )).to eql( json_sanitize( expect_str ))

    end

    it "#resource" do

      stubbed_template1 = ['"resu1":1' ]
      stubbed_template2 = [ ', "resu2":2' ', "resu3":3' ]
      
      expect_str = <<-EOS
    {"AWSTemplateFormatVersion":"2010-09-09", "Description":"", "Parameters":{  }, "Mappings": { },  "Resources":{  #{stubbed_template1.join} #{stubbed_template2.join} }, "Outputs":{}}
    EOS

      yaml_text = <<-EOF
        resources:
          - yksi
          - kaksi
      EOF

      expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :resources ).once.and_return( *stubbed_template1 )
      expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :resource ).twice.and_return( *stubbed_template2  )

      expect( json_sanitize( @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} ) )).to eql( json_sanitize( expect_str ))

    end
    
  end #   describe "Resources -section" do


end
