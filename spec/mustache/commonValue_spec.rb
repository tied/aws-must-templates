require_relative "spec_helper"

describe "commonValue" do

  def json_sanitize( str ) 
    return JSON.parse( "{ \"val\": #{str} }" )
  end


  before :each do
    @aws_must = AwsMust::AwsMust.new( { :template_path => "mustache"} )
  end

  describe "Attributes" do  

    it "#Ref'" do

      expect_str = '{ "Ref": "aaa"}'

      yaml_text = <<-EOF
        Ref: aaa
      EOF

      expect( json_sanitize( @aws_must.generate_str( "commonValue", stubbaa( yaml_text ), {} ) )).to eql( json_sanitize( expect_str ))


    end

    it "#Value'" do

      expect_str = '"bbb"'

      yaml_text = <<-EOF
        Value: bbb
      EOF

      expect( json_sanitize( @aws_must.generate_str( "commonValue", stubbaa( yaml_text ), {} ) )).to eql( json_sanitize( expect_str ))

    end


    it "#Attr'" do

      expect_str = '{"Fn::GetAtt": ["refffi", "nimi"]}'

      yaml_text = <<-EOF
        Attr:
           Ref: refffi
           Name: nimi
      EOF

      expect( json_sanitize( @aws_must.generate_str( "commonValue", stubbaa( yaml_text ), {} ) )).to eql( json_sanitize( expect_str ))

    end

    it "#StackRef'" do

      expect_str = '{"Fn::GetAtt": ["pino", "Outputs.outoutout"]}'

      yaml_text = <<-EOF
        StackRef:
           Stack: pino
           Output: outoutout
      EOF

      expect( json_sanitize( @aws_must.generate_str( "commonValue", stubbaa( yaml_text ), {} ) )).to eql( json_sanitize( expect_str ))

    end


  end



end
