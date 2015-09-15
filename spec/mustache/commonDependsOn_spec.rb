require_relative "spec_helper"

template_under_test = "commonDependsOn"

describe template_under_test do

  let( :template_dir ) { "mustache" }

  dummy_element = '"dummy": "value"'


  before :each do
    @aws_must = AwsMust::AwsMust.new( { :template_path => template_dir } )

    # hide partials
    allow_any_instance_of( AwsMust::Template ).to receive( :partial ).with( any_args ).and_return( "" )
    # verify that template_under_test actually used
    expect_any_instance_of( AwsMust::Template ).to receive( :get_template ).with( template_under_test  ).and_call_original

  end

  describe "Attributes" do  

    # ------------------------------------------------------------------

    it "#string'" do

      expect_str = <<-EOS
        , "DependsOn" : "heivaan"
      EOS

      yaml_text = <<-EOF
          DependsOn: heivaan
      EOF

      # debug
      # puts json_sanitize( dummy_element + expect_str, nil  )

      render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )

      # debug
      # puts "render_str1=#{render_str}"
      # puts json_sanitize( dummy_element + render_str, nil  )

      expect( json_sanitize( dummy_element + render_str, nil )).to eql( json_sanitize( dummy_element + expect_str, nil  ))

    end

    # ------------------------------------------------------------------

    it "#array" do

      expect_str = <<-EOS
           , "DependsOn" : ["hei", "maailma"]
      EOS

      yaml_text = <<-EOF
           DependsOn: 
            - hei
            - maailma
      EOF

      # debug
      # puts json_sanitize( dummy_element + expect_str, nil  )

      render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )

      # debug
      # puts "render_str2=#{render_str}"
      # puts json_sanitize( dummy_element + render_str, nil  )

      expect( json_sanitize( dummy_element + render_str, nil )).to eql( json_sanitize( dummy_element + expect_str, nil  ))

    end

    # ------------------------------------------------------------------

    it "#empty" do

      expect_str = <<-EOS
      EOS

      yaml_text = <<-EOF
              apu: koe
      EOF

      # debug
      # puts json_sanitize( dummy_element + expect_str, nil  )

      render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )

      # debug
      # puts "render_str2=#{render_str}"
      # puts json_sanitize( dummy_element + render_str, nil  )

      expect( json_sanitize( dummy_element + render_str, nil )).to eql( json_sanitize( dummy_element + expect_str, nil  ))

    end




  end # describe "Attributes" do  



end
