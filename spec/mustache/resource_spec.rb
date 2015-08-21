require_relative "spec_helper"

template_under_test = "resource"

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

  it "#empty YAML'" do

    expect_str= ""

    yaml_text = <<-EOF
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

  it "#Instance'" do

    stubbed_template =  [ '{"Instance": "rendered"}' ]

    expect_str= "#{stubbed_template.join}"

    yaml_text = <<-EOF
       Instance: true
    EOF

    # debug
    # puts "expect_str=#{expect_str}"
    # puts json_sanitize( expect_str + dummy_element)

    expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :resourceInstance ).once.and_return( *stubbed_template )

    # invoke template
    render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )
    
    # debug
    # puts "render_str=#{render_str}"
    # puts json_sanitize( render_str + dummy_element  )

    expect( json_sanitize( render_str + dummy_element  )).to eql( json_sanitize( expect_str  + dummy_element ))

  end

  it "#SecurityGroup'" do

    stubbed_template =  [ '{"SecurityGroup": "rendered"}' ]

    expect_str= "#{stubbed_template.join}"

    yaml_text = <<-EOF
       SecurityGroup: true
    EOF

    # debug
    # puts "expect_str=#{expect_str}"
    # puts json_sanitize( expect_str + dummy_element)

    expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :resourceSecurityGroup ).once.and_return( *stubbed_template )

    # invoke template
    render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )
    
    # debug
    # puts "render_str=#{render_str}"
    # puts json_sanitize( render_str + dummy_element  )

    expect( json_sanitize( render_str + dummy_element  )).to eql( json_sanitize( expect_str  + dummy_element ))

  end


  it "#S3Bucket'" do

    stubbed_template =  [ '{"partial": "rendered"}' ]

    expect_str= "#{stubbed_template.join}"

    yaml_text = <<-EOF
       S3Bucket: true
    EOF

    # debug
    # puts "expect_str=#{expect_str}"
    # puts json_sanitize( expect_str + dummy_element)

    expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :resourceS3Bucket ).once.and_return( *stubbed_template )

    # invoke template
    render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )
    
    # debug
    # puts "render_str=#{render_str}"
    # puts json_sanitize( render_str + dummy_element  )

    expect( json_sanitize( render_str + dummy_element  )).to eql( json_sanitize( expect_str  + dummy_element ))

  end

  it "#Role'" do

    stubbed_template =  [ '{"partial": "rendered"}' ]

    expect_str= "#{stubbed_template.join}"

    yaml_text = <<-EOF
       Role: true
    EOF

    # debug
    # puts "expect_str=#{expect_str}"
    # puts json_sanitize( expect_str + dummy_element)

    expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :resourceRole ).once.and_return( *stubbed_template )

    # invoke template
    render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )
    
    # debug
    # puts "render_str=#{render_str}"
    # puts json_sanitize( render_str + dummy_element  )

    expect( json_sanitize( render_str + dummy_element  )).to eql( json_sanitize( expect_str  + dummy_element ))

  end

  it "#Policy'" do

    stubbed_template =  [ '{"partial": "rendered"}' ]

    expect_str= "#{stubbed_template.join}"

    yaml_text = <<-EOF
       Policy: true
    EOF

    # debug
    # puts "expect_str=#{expect_str}"
    # puts json_sanitize( expect_str + dummy_element)

    expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :resourcePolicy ).once.and_return( *stubbed_template )

    # invoke template
    render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )
    
    # debug
    # puts "render_str=#{render_str}"
    # puts json_sanitize( render_str + dummy_element  )

    expect( json_sanitize( render_str + dummy_element  )).to eql( json_sanitize( expect_str  + dummy_element ))

  end

  it "#InstanceProfile'" do

    stubbed_template =  [ '{"partial": "rendered"}' ]

    expect_str= "#{stubbed_template.join}"

    yaml_text = <<-EOF
       InstanceProfile: true
    EOF

    # debug
    # puts "expect_str=#{expect_str}"
    # puts json_sanitize( expect_str + dummy_element)

    expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :resourceInstanceProfile ).once.and_return( *stubbed_template )

    # invoke template
    render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )
    
    # debug
    # puts "render_str=#{render_str}"
    # puts json_sanitize( render_str + dummy_element  )

    expect( json_sanitize( render_str + dummy_element  )).to eql( json_sanitize( expect_str  + dummy_element ))

  end


  it "#Stack'" do

    stubbed_template =  [ '{"partial": "rendered"}' ]

    expect_str= "#{stubbed_template.join}"

    yaml_text = <<-EOF
       Stack: true
    EOF

    # debug
    # puts "expect_str=#{expect_str}"
    # puts json_sanitize( expect_str + dummy_element)

    expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :resourceStack ).once.and_return( *stubbed_template )

    # invoke template
    render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )
    
    # debug
    # puts "render_str=#{render_str}"
    # puts json_sanitize( render_str + dummy_element  )

    expect( json_sanitize( render_str + dummy_element  )).to eql( json_sanitize( expect_str  + dummy_element ))

  end

  it "#Wait'" do

    stubbed_template =  [ '{"partial": "rendered"}' ]

    expect_str= "#{stubbed_template.join}"

    yaml_text = <<-EOF
       Wait: true
    EOF

    # debug
    # puts "expect_str=#{expect_str}"
    # puts json_sanitize( expect_str + dummy_element)

    expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :resourceWait ).once.and_return( *stubbed_template )

    # invoke template
    render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )
    
    # debug
    # puts "render_str=#{render_str}"
    # puts json_sanitize( render_str + dummy_element  )

    expect( json_sanitize( render_str + dummy_element  )).to eql( json_sanitize( expect_str  + dummy_element ))

  end

  it "#VPC'" do

    stubbed_template =  [ '{"partial": "rendered"}' ]

    expect_str= "#{stubbed_template.join}"

    yaml_text = <<-EOF
       VPC: true
    EOF

    # debug
    # puts "expect_str=#{expect_str}"
    # puts json_sanitize( expect_str + dummy_element)

    expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :resourceVPC ).once.and_return( *stubbed_template )

    # invoke template
    render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )
    
    # debug
    # puts "render_str=#{render_str}"
    # puts json_sanitize( render_str + dummy_element  )

    expect( json_sanitize( render_str + dummy_element  )).to eql( json_sanitize( expect_str  + dummy_element ))

  end

  it "#Subnet'" do

    stubbed_template =  [ '{"partial": "rendered"}' ]

    expect_str= "#{stubbed_template.join}"

    yaml_text = <<-EOF
       Subnet: true
    EOF

    # debug
    # puts "expect_str=#{expect_str}"
    # puts json_sanitize( expect_str + dummy_element)

    expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :resourceSubnet ).once.and_return( *stubbed_template )

    # invoke template
    render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )
    
    # debug
    # puts "render_str=#{render_str}"
    # puts json_sanitize( render_str + dummy_element  )

    expect( json_sanitize( render_str + dummy_element  )).to eql( json_sanitize( expect_str  + dummy_element ))

  end


  it "#InternetGateway'" do

    stubbed_template =  [ '{"partial": "rendered"}' ]

    expect_str= "#{stubbed_template.join}"

    yaml_text = <<-EOF
       InternetGateway: true
    EOF

    # debug
    # puts "expect_str=#{expect_str}"
    # puts json_sanitize( expect_str + dummy_element)

    expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :resourceInternetGateway ).once.and_return( *stubbed_template )

    # invoke template
    render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )
    
    # debug
    # puts "render_str=#{render_str}"
    # puts json_sanitize( render_str + dummy_element  )

    expect( json_sanitize( render_str + dummy_element  )).to eql( json_sanitize( expect_str  + dummy_element ))

  end

  it "#User'" do

    stubbed_template =  [ '{"partial": "rendered"}' ]

    expect_str= "#{stubbed_template.join}"

    yaml_text = <<-EOF
       User: true
    EOF

    # debug
    # puts "expect_str=#{expect_str}"
    # puts json_sanitize( expect_str + dummy_element)

    expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :resourceUser ).once.and_return( *stubbed_template )

    # invoke template
    render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )
    
    # debug
    # puts "render_str=#{render_str}"
    # puts json_sanitize( render_str + dummy_element  )

    expect( json_sanitize( render_str + dummy_element  )).to eql( json_sanitize( expect_str  + dummy_element ))

  end














end
