require 'spec_helper'

current_test = "ValidOSVersion"


describe current_test do

  # ------------------------------------------------------------------
  # test parameters

  codename = test_parameter( current_test, "Codename" )

  describe "Operating system codename '#{codename.value}'" do

    describe command('lsb_release --c -s') do
      its( :stdout ) { should match /#{codename.value}/ }
    end

  end



end

