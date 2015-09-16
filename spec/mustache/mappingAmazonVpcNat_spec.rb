require_relative "spec_helper"

template_under_test = "mappingAmazonVpcNat"

describe template_under_test do


  let( :template_dir ) { "mustache" }

  dummy_element = ''


  before :each do
    @aws_must = AwsMust::AwsMust.new( { :template_path => template_dir } )

    # hide partials
    allow_any_instance_of( AwsMust::Template ).to receive( :partial ).with( any_args ).and_return( "" )
    # verify that template_under_test actually used
    expect_any_instance_of( AwsMust::Template ).to receive( :get_template ).with( template_under_test  ).and_call_original

  end


  it "#outpus mapping table" do
    name = "koe"
    expect_str= <<-EOS
        "NatRegionMap" : {
          "eu-west-1": {
            "AMI": "ami-8fdaf9f8"
          },
          "ap-southeast-1": {
            "AMI": "ami-a05c49f2"
          },
          "ap-southeast-2": {
            "AMI": "ami-6988c753"
          },
          "eu-central-1": {
            "AMI": "ami-c63b3bdb"
          },
          "ap-northeast-1": {
            "AMI": "ami-f88613f8"
          },
          "us-east-1": {
            "AMI": "ami-5d761d38"
          },
          "sa-east-1": {
            "AMI": "ami-438e1b5e"
          },
          "us-west-1": {
            "AMI": "ami-57975213"
          },
          "us-west-2": {
            "AMI": "ami-b5021e85"
          }
        }
    EOS

    # puts json_sanitize( dummy_element + expect_str, nil  )

    yaml_text = <<-EOF
      Name: #{name}
    EOF

    render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )

    # puts "render_str1=#{render_str}"
    # puts json_sanitize( dummy_element + render_str, nil  )

    expect( json_sanitize( render_str, nil )).to eql( json_sanitize( expect_str, nil  ))

  end


end
