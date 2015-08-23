require_relative "spec_helper"

template_under_test = "initializeStartCfnHup"

describe template_under_test do


  let( :template_dir ) { "mustache" }

  before :each do
    @aws_must = AwsMust::AwsMust.new( { :template_path => template_dir } )

    # hide partials
    allow_any_instance_of( AwsMust::Template ).to receive( :partial ).with( any_args ).and_return( "" )
    # verify that template_under_test actually used
    expect_any_instance_of( AwsMust::Template ).to receive( :get_template ).with( template_under_test  ).and_call_original

  end

  before :each do

    @expect_resource="resut"
    
    yaml_text = <<-EOS
         Resource: #{@expect_resource}
      EOS
    @render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )
    # puts @render_str
  end

  it "#cfn-hup" do
    expect( @render_str ).to match( /cfn-hup/  )
  end



end
