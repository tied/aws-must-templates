require_relative "spec_helper"

template_under_test = "resourceProvisionChef"


describe template_under_test do


  let( :template_dir ) { "mustache" }

  before :each do
    @aws_must = AwsMust::AwsMust.new( { :template_path => template_dir } )

    # hide partials
    allow_any_instance_of( AwsMust::Template ).to receive( :partial ).with( any_args ).and_return( "" )
    # verify that template_under_test actually used
    expect_any_instance_of( AwsMust::Template ).to receive( :get_template ).with( template_under_test  ).and_call_original

  end

  
  describe "#default"  do

    before :each do
      yaml_text = <<-EOS
       Node: n1
      EOS
      @render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )
    end

    it "#defines NODE'" do
      expect( @render_str ).to include( 'NODE=n1'  )
    end

    it "#sudo chef-client'" do
      expect( @render_str ).to include( 'sudo chef-client'  )
    end


  end


end

