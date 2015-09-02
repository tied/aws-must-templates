require_relative "spec_helper"

template_under_test = "resourcePolicy"

describe template_under_test do

  dummy_element = ""

  let( :template_dir ) { "mustache" }

  before :each do
    @aws_must = AwsMust::AwsMust.new( { :template_path => template_dir } )

    # hide partials
    allow_any_instance_of( AwsMust::Template ).to receive( :partial ).with( any_args ).and_return( "" )
    # verify that template_under_test actually used
    expect_any_instance_of( AwsMust::Template ).to receive( :get_template ).with( template_under_test  ).and_call_original

  end

  it "#default'" do

    expect_str= <<-EOS
      "testPoolyicy" : {
            "Type" : "AWS::IAM::Policy",
            "Properties" : {
                "PolicyName" : "testPoolyicy",
                "Roles" : [ { "Ref" : "" } ],
                "PolicyDocument" : {
                    "Statement" : [ 
                    ]
                }
            }
        }
    EOS

    yaml_text = <<-EOF
     Name: testPoolyicy
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


  it "#statements'" do

    expect_str= <<-EOS
      "testPoolyicy" : {
            "Type" : "AWS::IAM::Policy",
            "Properties" : {
                "PolicyName" : "testPoolyicy",
                "Roles" : [ { "Ref" : "" } ],
                "PolicyDocument" : {
                    "Statement" : [ 

                 {
                    "Effect" : "effeksi",
                    "Action" : [ "aktions" ],
                    "Resource" :  {  "Fn::Join" : [ "", [  "resu"  ] ] }
                 }

                    ]
                }
            }
        }
    EOS

    yaml_text = <<-EOF
     Name: testPoolyicy
     Statements:
       - Effect: effeksi
         Actions: '"aktions"'
         Resource: 
            - Value: resu
    EOF

    # debug
    # puts json_sanitize( expect_str + dummy_element, nil )

    allow_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :commonValue ).and_call_original

    # invoke template
    render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )
    
    # debug
    # puts "render_str=#{render_str}"
    # puts json_sanitize( render_str + dummy_element , nil  )

    expect( json_sanitize( render_str + dummy_element, nil )).to eql( json_sanitize( expect_str  + dummy_element, nil ))

  end




end
