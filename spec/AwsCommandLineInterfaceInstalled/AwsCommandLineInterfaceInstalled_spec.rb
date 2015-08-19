require 'spec_helper'

describe "AwsCommandLineInterfaceInstalled" do 

  describe command('type aws') do
      its( :exit_status ) { should eq 0 }
  end


end
