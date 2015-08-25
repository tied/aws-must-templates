require 'spec_helper'


describe "S3ReadAccessAllowed" do

  bucket_name =  stack_output( 'Bucket' ).value 
  test_file="ttest.tmp"

  # ------------------------------------------------------------------
  # Stack parameters && outputs

  describe "Stack" do 

    it "#defines bucket_name"  do
      expect( bucket_name ).not_to eql( nil )
    end

  end

  # ------------------------------------------------------------------
  # aws Command line interface installed

  context "Operating system context" do 

    describe "Aws Commad Line Interface (CLI) is installed" do 
      describe command('type aws') do
        its( :exit_status ) { should eq 0 }
      end
    end

  end

  # ------------------------------------------------------------------
  # Context

  context "When read access to a S3 bucket granted" do 

    describe "Can list S3 buckets" do 
      describe command('aws s3 ls') do
        its( :exit_status ) { should eq 0 }
      end
    end

    describe "Can list S3 bucket keys" do 

      subject { command( "aws s3 ls s3://#{bucket_name} --region $(aws s3api get-bucket-location --bucket #{bucket_name} --output text)").exit_status }
      it { is_expected.to eql 0 }

    end


    context "When an Object exists in S3 bucket" do 

      before(:context) do
        cmd =  "echo tst | aws s3 cp - s3://#{bucket_name}/#{test_file}"
        `#{cmd}`
        raise "Error in '#{cmd}' " unless $? == 0
      end

      after(:context) do
        cmd = "aws s3 rm  s3://#{bucket_name}/#{test_file}"
        `#{cmd}`
        raise "Error in '#{cmd}' " unless $? == 0
      end

      # Using "serverspec" style here

      describe "Can read the Object from a S3 bucket" do 

        describe command("aws s3 cp s3://#{bucket_name}/#{test_file} /tmp/#{test_file} --region $(aws s3api get-bucket-location --bucket #{bucket_name} --output text)") do
          its( :exit_status ) { should eq 0 }
        end

      end

      # using subject + expect style
      describe "Cannot modify (= delete) the  Object in bucket" do

        subject { command("aws s3 rm s3://#{@bucket_name}/#{test_file} --region $(aws s3api get-bucket-location --bucket #{@bucket_name} --output text)") }
        it { expect( subject.exit_status ).not_to eql 0 }

      end

    end # context test_file in bucket

    # subject + it is_expected one liner
    describe "Cannot write to bucket" do 

      describe "Create an Object in bucket should fail" do
        subject { command("aws s3 cp /etc/hosts  s3://#{@bucket_name}/#{test_file} --region $(aws s3api get-bucket-location --bucket #{@bucket_name} --output text)").exit_status }
        it { is_expected.not_to eql 0  }
      end

    end


  end

  # ------------------------------------------------------------------
  # 

  context "When bucket does not exists" do 

    describe "Cannot list S3 bucket keys" do 

      describe command( "aws s3 ls s3://DASKLjwKLJ4534Buckert --region $(aws s3api get-bucket-location --bucket #{@bucket_name} --output text)") do
        its( :exit_status ) { should_not eq 0 }
      end
    end

  end


end
