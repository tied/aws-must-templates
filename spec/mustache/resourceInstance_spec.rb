require_relative "spec_helper"

template_under_test = "resourceInstance"


describe template_under_test do


  let( :template_dir ) { "mustache" }

  before :each do
    @aws_must = AwsMust::AwsMust.new( { :template_path => template_dir } )

    # hide partials
    allow_any_instance_of( AwsMust::Template ).to receive( :partial ).with( any_args ).and_return( "" )
    allow_any_instance_of( AwsMust::Template ).to receive( :partial ).with( /common/ ).and_call_original
    allow_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :resourceInstanceInitialize ).and_return( '{}' )
    # verify that template_under_test actually used
    expect_any_instance_of( AwsMust::Template ).to receive( :get_template ).with( template_under_test  ).and_call_original

  end


  # ------------------------------------------------------------------
  # default
  it "#default'" do

    expect_str= <<-EOS
           "koe" : {"Type":"AWS::EC2::Instance"
                     , "DependsOn": "riippuu"
                     , "Metadata":{}
                     , "Properties":{
                           "ImageId":{"Fn::FindInMap":["AWSRegionArch2AMI", {"Ref":"AWS::Region"}, {"Fn::FindInMap":["AWSInstanceType2Arch", "commonInstanceType-partial called", "Arch"]}]}
                         , "InstanceType":"commonInstanceType-partial called"
                         , "Tags":[{"Key":"Name", "Value":"koe"}]
                         , "SecurityGroupIds":[]
                         , "UserData":{}
                         , "SourceDestCheck": true
                     }
                   }
    EOS

    yaml_text = <<-EOF
      Name: koe
      InstanceType: t2.micro
      DependsOn: riippuu
    EOF

    # debug
    # puts json_sanitize( expect_str, nil  )

    # stub partials 
    expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :commonInstanceType ).twice.and_return( '"commonInstanceType-partial called"' )
    expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :resourceInstanceInitialize ).and_return( '{}' )

    render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )
    
    # debug
    # puts "render_str=#{render_str}"
    # puts json_sanitize( render_str, nil  )

    expect( json_sanitize( render_str, nil )).to eql( json_sanitize( expect_str, nil  ))

  end

  # ------------------------------------------------------------------
  # SourceDestCheck

  it "#SourceDestCheck" do

    expect_str= <<-EOS
           "koesource_dest_check" : {
               "Type":"AWS::EC2::Instance"
              , "Metadata":{}
              , "Properties":{
                    "ImageId":{"Fn::FindInMap":["AWSRegionArch2AMI", {"Ref":"AWS::Region"}, {"Fn::FindInMap":["AWSInstanceType2Arch", "commonInstanceType-partial called", "Arch"]}]}
                    , "InstanceType":"commonInstanceType-partial called"
                    , "Tags":[{"Key":"Name", "Value":"koesource_dest_check"}]
                    , "SecurityGroupIds":[]
                    , "UserData":{}
                    , "SourceDestCheck": false
               }
            }
    EOS

    yaml_text = <<-EOF
      Name: koesource_dest_check
      InstanceType: t2.micro
      SourceDestCheck: "false"
    EOF

    # debug
    # puts json_sanitize( expect_str, nil  )

    # stub partials 
    expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :commonInstanceType ).twice.and_return( '"commonInstanceType-partial called"' )
    expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :resourceInstanceInitialize ).and_return( '{}' )

    render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )
    
    # debug
    # puts "render_str=#{render_str}"
    # puts json_sanitize( render_str, nil  )

    expect( json_sanitize( render_str, nil )).to eql( json_sanitize( expect_str, nil  ))

  end

  # ------------------------------------------------------------------
  # 


  it "#MapRegionToImageId" do

    expect_str= <<-EOS
           "koesource_dest_check" : {
               "Type":"AWS::EC2::Instance"
              , "Metadata":{}
              , "Properties":{
                    "ImageId": {"Fn::FindInMap" : ["mappaa", {"Ref" : "AWS::Region"}, "AMI"]}
                    , "InstanceType": "t2.micro"
                    , "Tags":[{"Key":"Name", "Value":"koesource_dest_check"}]
                    , "SecurityGroupIds":[]
                    , "UserData":{}
                    , "SourceDestCheck": true
               }
            }
    EOS

    yaml_text = <<-EOF
      Name: koesource_dest_check
      InstanceType: t2.micro
      MapRegionToImageId: mappaa
    EOF

    # debug
    # puts json_sanitize( expect_str, nil  )

    # stub partials 
    render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )
    
    # debug
    # puts "render_str=#{render_str}"
    # puts json_sanitize( render_str, nil  )

    expect( json_sanitize( render_str, nil )).to eql( json_sanitize( expect_str, nil  ))

  end


end

