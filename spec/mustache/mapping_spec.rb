require_relative "spec_helper"

template_under_test = "mapping"

describe template_under_test do

  let( :template_dir ) { "mustache" }

  dummy_element = ""


  # def json_sanitize( str ) 
  #   return JSON.parse( str )
  # end

  before :each do
    @aws_must = AwsMust::AwsMust.new( { :template_path => template_dir } )

    # hide partials
    allow_any_instance_of( AwsMust::Template ).to receive( :partial ).with( any_args ).and_return( "" )
    # verify that template_under_test actually used
    expect_any_instance_of( AwsMust::Template ).to receive( :get_template ).with( template_under_test  ).and_call_original

  end

  # ------------------------------------------------------------------
  # 
  it "#AmazonVpcNat" do

    stubbed_template =  [ '{"Instance": "rendered"}' ]

    expect_str= "#{stubbed_template.join}"

    yaml_text = <<-EOF
       AmazonVpcNat: true
    EOF

    # debug
    # puts "expect_str=#{expect_str}"
    # puts json_sanitize( expect_str + dummy_element)

    expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :mappingAmazonVpcNat ).once.and_return( *stubbed_template )

    # invoke template
    render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )
    
    # debug
    # puts "render_str=#{render_str}"
    # puts json_sanitize( render_str + dummy_element  )

    expect( json_sanitize( render_str + dummy_element  )).to eql( json_sanitize( expect_str  + dummy_element ))

  end

  # ------------------------------------------------------------------

  it "#SubnetConfig" do

    stubbed_template =  [ '{"Instance": "rendered"}' ]

    expect_str= "#{stubbed_template.join}"

    yaml_text = <<-EOF
       SubnetConfig: true
    EOF

    # debug
    # puts "expect_str=#{expect_str}"
    # puts json_sanitize( expect_str + dummy_element)

    expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :mappingSubnetConfig ).once.and_return( *stubbed_template )

    # invoke template
    render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )
    
    # debug
    # puts "render_str=#{render_str}"
    # puts json_sanitize( render_str + dummy_element  )

    expect( json_sanitize( render_str + dummy_element  )).to eql( json_sanitize( expect_str  + dummy_element ))

  end

end
