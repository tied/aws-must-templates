require_relative "spec_helper"

template_under_test = "commonCfnSignal"

describe template_under_test do

  let( :template_dir ) { "mustache" }

  def str_sanitize( str ) 
    # return str.squeeze( "\n" )
    return str.gsub /^$\n/, ''
  end



  before :each do
    @aws_must = AwsMust::AwsMust.new( { :template_path => template_dir } )

    # hide partials
    allow_any_instance_of( AwsMust::Template ).to receive( :partial ).with( any_args ).and_return( "" )
    # verify that template_under_test actually used
    expect_any_instance_of( AwsMust::Template ).to receive( :get_template ).with( template_under_test  ).and_call_original

  end

  describe "Attributes" do  

    it "#WaitHandle'" do

      expect_str = 'cfn-signal'

      yaml_text = <<-EOF
          WaitHandle:
               Message: hello world
      EOF

      expect( str_sanitize( @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} ) )).to include( expect_str  )

    end


  end # describe "Attributes" do  



end
