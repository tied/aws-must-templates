require_relative "spec_helper"

template_under_test = "resourceInstanceMetadata"

describe template_under_test do


  let( :template_dir ) { "mustache" }

  before :each do
    @aws_must = AwsMust::AwsMust.new( { :template_path => template_dir } )

    # hide partials
    allow_any_instance_of( AwsMust::Template ).to receive( :partial ).with( any_args ).and_return( "" )
    # verify that template_under_test actually used
    expect_any_instance_of( AwsMust::Template ).to receive( :get_template ).with( template_under_test  ).and_call_original

  end

  
  describe "#empty YAML"  do

    it "#InstallCFtools" do

      expect_str= ""

      # puts json_sanitize( expect_str, nil  )

      yaml_text = <<-EOS
      EOS


      render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )
      # puts "render_str=#{render_str}"
      expect( json_sanitize( render_str, nil  )).to eql( json_sanitize( expect_str, nil  ))

    end

  end # describe "empty YAML"  do

  describe "#initiazlize defined"  do

    it "#InstallCFtools" do

      expect_str= <<-EOS
               "AWS::CloudFormation::Init":{
                         "config":{
                                "packages":{}
                              , "groups":{}
                              , "users":{}
                              , "sources":{}
                              , "files": {  
                                   "/tmp/cfn-init.txt": {
                                            "content": {
                                                  "Fn::Join":["", ["Installed in cfn-init", "\\n"]]
                                             }
                                          , "mode":"000444"
                                          , "owner":"root"
                                          , "group":"root"}}
                              , "commands":{}
                              , "services":{}
                          }
                  }
      EOS

      # puts json_sanitize( expect_str, nil  )

      yaml_text = <<-EOS
         Initialize:
         - aaa
      EOS


      render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )
      # puts "render_str=#{render_str}"
      expect( json_sanitize( render_str, nil  )).to eql( json_sanitize( expect_str, nil  ))

    end

  end # describe "empty YAML"  do



end

