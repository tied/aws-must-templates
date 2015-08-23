require_relative "spec_helper"

template_under_test = "resourceInstanceInitialize"

describe template_under_test do


  let( :template_dir ) { "mustache" }

  before :each do
    @aws_must = AwsMust::AwsMust.new( { :template_path => template_dir } )

    # hide partials
    allow_any_instance_of( AwsMust::Template ).to receive( :partial ).with( any_args ).and_return( "" )
    # verify that template_under_test actually used
    expect_any_instance_of( AwsMust::Template ).to receive( :get_template ).with( template_under_test  ).and_call_original

  end

  
  describe "empty YAML generates UserData bash -script"  do

    before :each do
      yaml_text = <<-EOS
      EOS
      @render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )
    end

    it "#defines /bin/bash -script" do
      expect( @render_str ).to include( '/bin/bash'  )
    end

    it "#trap finish EXIT" do
      expect( @render_str ).to include( 'function finish'  )
      expect( @render_str ).to include( 'trap finish EXIT'  )
    end

    it "#traps error ERR" do
      expect( @render_str ).to include( 'function error'  )
      expect( @render_str ).to include( "trap 'error ${LINENO}' ERR"  )
    end

  end

  # ------------------------------------------------------------------
  # Initiazlize arrays

  describe "Initizize"  do

    it "#InstallCFtools" do

      stubbed_template =  [ 'xx' ]
      expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :initializeCFtools ).once.and_return( *stubbed_template )

      yaml_text = <<-EOS
         Initialize:
           - InstallCFtools: true
      EOS

      render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )

    end

    it "#ProvisionChef" do

      stubbed_template =  [ 'xx' ]
      expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :initializeProvisionChef ).once.and_return( *stubbed_template )

      yaml_text = <<-EOS
         Initialize:
           - ProvisionChef: true
      EOS

      render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )

    end

    it "#InstallAwsCli" do

      stubbed_template =  [ 'xx' ]
      expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :initializeInstallAwsCli ).once.and_return( *stubbed_template )


      yaml_text = <<-EOS
         Initialize:
           - InstallAwsCli: true
      EOS

      render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )

    end

    it "#InstallChef" do

      stubbed_template =  [ 'xx' ]
      expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :initializeInstallChef ).once.and_return( *stubbed_template )


      yaml_text = <<-EOS
         Initialize:
           - InstallChef: true
      EOS

      render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )

    end

    it "#LaunchChefZero" do

      stubbed_template =  [ 'xx' ]
      expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :initializeProvisionChefZero ).once.and_return( *stubbed_template )


      yaml_text = <<-EOS
         Initialize:
           - LaunchChefZero: true
      EOS

      render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )

    end


    it "#StartCfnInit" do

      stubbed_template =  [ 'xx' ]
      expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :initializeCFinit ).once.and_return( *stubbed_template )

      yaml_text = <<-EOS
         Initialize:
           - StartCfnInit: true
      EOS

      render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )

    end

    it "#StartCfnHup" do

      stubbed_template =  [ 'xx' ]
      expect_any_instance_of( AwsMust::Template ).to receive( :partial ).with( :initializeStartCfnHup ).once.and_return( *stubbed_template )

      yaml_text = <<-EOS
         Initialize:
           - StartCfnHup: true
      EOS

      render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )

    end




  end #describe "Initizize"  do

end

