require 'spec_helper'

describe "CloudFormationHelperScriptsInstalled" do 

  describe command('type cfn-init') do
      its( :exit_status ) { should eq 0 }
  end

  describe command('type cfn-signal') do
      its( :exit_status ) { should eq 0 }
  end

  describe command('type cfn-get-metadata') do
      its( :exit_status ) { should eq 0 }
  end

  describe command('type cfn-hup') do
      its( :exit_status ) { should eq 0 }
  end

end
