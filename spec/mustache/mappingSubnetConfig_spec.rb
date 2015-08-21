require_relative "spec_helper"

template_under_test = "mappingSubnetConfig"

describe template_under_test do


  let( :template_dir ) { "mustache" }

  before :each do
    @aws_must = AwsMust::AwsMust.new( { :template_path => template_dir } )

    # hide partials
    allow_any_instance_of( AwsMust::Template ).to receive( :partial ).with( any_args ).and_return( "" )
    # verify that template_under_test actually used
    expect_any_instance_of( AwsMust::Template ).to receive( :get_template ).with( template_under_test  ).and_call_original

  end


  it "#Name in YAML'" do

    name = "koe"
    expect_str= <<-EOS
      "#{name}": 
       {
      "VPC"     : { "CIDR" : "10.44.0.0/16" },
      "Public"  : { "CIDR" : "10.44.0.0/24" },
      "Private" : { "CIDR" : "10.44.1.0/24" }
       }
    EOS

    yaml_text = <<-EOF
      Name: #{name}
    EOF

    render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )
    expect( json_sanitize( render_str, nil )).to eql( json_sanitize( expect_str, nil  ))

  end




end
