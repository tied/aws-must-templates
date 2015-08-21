require_relative "spec_helper"

template_under_test = "resourceInstanceProfile"

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

  it "#default'" do

    expect_str= <<-EOS
           "koe" : {
                "Type" : "AWS::IAM::InstanceProfile",
                 "Properties" : {
                  "Path" : "/",
                  "Roles" : [ ]
             }
          },
    EOS

    yaml_text = <<-EOF
      Name: koe
      InstanceType: t2.micro
    EOF

    # debug
    # puts json_sanitize( expect_str, nil  )

    # invoke template
    render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )
    
    # debug
    # puts "render_str=#{render_str}"
    # puts json_sanitize( render_str + dummy_element , nil  )

    expect( json_sanitize( render_str + dummy_element, nil )).to eql( json_sanitize( expect_str  + dummy_element, nil  ))

  end


end

