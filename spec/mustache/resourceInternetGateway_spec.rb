require_relative "spec_helper"

template_under_test = "resourceInternetGateway"

describe template_under_test do

  let( :template_dir ) { "mustache" }

  dummy_element = ''

  before :each do
    @aws_must = AwsMust::AwsMust.new( { :template_path => template_dir } )

    # hide partials
    allow_any_instance_of( AwsMust::Template ).to receive( :partial ).with( any_args ).and_return( "" )
    allow_any_instance_of( AwsMust::Template ).to receive( :partial ).with( /common/).and_call_original

    # verify that template_under_test actually used
    expect_any_instance_of( AwsMust::Template ).to receive( :get_template ).with( template_under_test  ).and_call_original

  end

  it "#default'" do

    expect_str= <<-EOS

        "koe" : {
            "Type" : "AWS::EC2::InternetGateway",
            "Properties" : {
               "Tags" : [ {"Key":"Name", "Value":"koe"} ]
            }
         },
        
        "attachekoe" : {
              "Type" : "AWS::EC2::VPCGatewayAttachment",
              "Properties" : {
                "VpcId" : { "Ref" : "vpcid" },
                "InternetGatewayId" : { "Ref" : "koe" }
            }
        }, 
        
        
        
        "RouteTable" : {
              "Type" : "AWS::EC2::RouteTable",
              "Properties" : {
                "VpcId" : { "Ref" : "" },
                "Tags" : [ 
        		           {"Key": "Name", "Value" : "RouteTable" }
        		         , {"Key" : "Application", "Value" : { "Ref" : "AWS::StackId"} } 
        				 ]
              }
            },
        
        "Route" : {
            "Type" : "AWS::EC2::Route",
             "DependsOn" : "Attach",
              "Properties" : {
                  "RouteTableId" : { "Ref" : "RouteTable" }
                  , "DestinationCidrBlock" : "0.0.0.0/0"
                  , "GatewayId" : { "Ref" : "koe" }
             }
        },
        
        
        "RouteTableAssociation" : {
            "Type" : "AWS::EC2::SubnetRouteTableAssociation"
           , "Properties" : {
                 "SubnetId" : { "Ref" : "" }
               , "RouteTableId" : { "Ref" : "RouteTable" }
             }
        }

    EOS

    yaml_text = <<-EOF
      Name: koe
      Attachment: 
         AttachmentName: attachekoe
         Vpc: vpcid
    EOF

    # debug
    # puts json_sanitize( expect_str + dummy_element, nil )

    # invoke template
    render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )
    
    # debug
    # puts "render_str=#{render_str}"
    # puts json_sanitize( render_str + dummy_element , nil  )

    expect( json_sanitize( render_str + dummy_element, nil )).to eql( json_sanitize( expect_str  + dummy_element, nil ))

  end


end

