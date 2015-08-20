require 'spec_helper'

expected_properties = [
 ['Outputs', 'Bucket' ],
]

describe "S3ReadAccessAllowed" do

  # ------------------------------------------------------------------
  # Stack parameters && outputs

  describe "Stack parameters and outputs" do 

    expected_properties.each do | keys |
      describe valid_property( property, keys ) do
        its( :value ) { should_not eq nil } 
      end

    end

  end

  # ------------------------------------------------------------------
  # aws Command line interface installed

  context "Package installation" do 

    describe "Has aws command line tools installed" do 
      describe command('type aws') do
        its( :exit_status ) { should eq 0 }
      end
    end

  end

  # ------------------------------------------------------------------
  # Context

  context "When read access to bucket granted" do 

    describe "Can list S3 buckets" do 
      describe command('aws s3 ls') do
        its( :exit_status ) { should eq 0 }
      end
    end

    describe "Can list S3 bucket keys" do 
      
      describe command( "aws s3 ls s3://#{property['Outputs']['Bucket']} --region $(aws s3api get-bucket-location --bucket #{property['Outputs']['Bucket']} --output text)") do
        its( :exit_status ) { should eq 0 }
      end

    end

    test_file="ttest.tmp"

    context "When file 's3://#{property['Outputs']['Bucket']}/#{test_file}' exists in bucket" do 


      before(:all) do
        cmd =  "echo tst | aws s3 cp - s3://#{property['Outputs']['Bucket']}/#{test_file}"
        `#{cmd}`
        raise "Error in '#{cmd}' " unless $? == 0
      end

      after(:all) do
        cmd = "aws s3 rm  s3://#{property['Outputs']['Bucket']}/#{test_file}"
        `#{cmd}`
        raise "Error in '#{cmd}' " unless $? == 0
      end
      

      describe "Can read an object (= '#{test_file}') from S3 bucket" do 

        describe command("aws s3 cp s3://#{property['Outputs']['Bucket']}/#{test_file} /tmp/#{test_file} --region $(aws s3api get-bucket-location --bucket #{property['Outputs']['Bucket']} --output text)") do
          its( :exit_status ) { should eq 0 }
        end

      end

      describe "Cannot modify bucket = delete an object (= '#{test_file}') from S3 bucket" do 

        describe command("aws s3 rm s3://#{property['Outputs']['Bucket']}/#{test_file} --region $(aws s3api get-bucket-location --bucket #{property['Outputs']['Bucket']} --output text)") do
          its( :exit_status ) { should_not eq 0 }
        end

      end


    end # context test_file in bucket

    describe "Cannot write to bucket" do 

        describe command("aws s3 cp /etc/hosts  s3://#{property['Outputs']['Bucket']}/#{test_file} --region $(aws s3api get-bucket-location --bucket #{property['Outputs']['Bucket']} --output text)") do
          its( :exit_status ) { should_not eq 0 }
        end

    end


  end

  # ------------------------------------------------------------------
  # 

  context "When bucket does not exists" do 

    describe "Cannot list S3 bucket keys " do 
      describe command( "aws s3 ls s3://#{property['Outputs']['Bucket']}2 --region $(aws s3api get-bucket-location --bucket #{property['Outputs']['Bucket']} --output text)") do
        its( :exit_status ) { should_not eq 0 }
      end
    end

  end


end
