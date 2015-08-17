require 'spec_helper'

expected_properties = [
 [:Parameters, :BucketName ],
]

describe "Ensure that cloudformation stack parameters && outputs define mandatory value" do 

  expected_properties.each do | propArra |
    it "Property #{propArra} must not be nil" do
      props = property
      propArra.each do |k|
        expect( props[k.to_sym] ).not_to eql nil
        props = props[k]
      end
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
    
    describe command( "aws s3 ls s3://#{property[:Parameters][:BucketName]} --region $(aws s3api get-bucket-location --bucket #{property[:Parameters][:BucketName]} --output text)") do
      its( :exit_status ) { should eq 0 }
    end

  end

  test_file="ttest.tmp"

  context "and file 's3://#{property[:Parameters][:BucketName]}/#{test_file}' exists" do 


    before(:all) do
      cmd =  "echo tst | aws s3 cp - s3://#{property[:Parameters][:BucketName]}/#{test_file}"
      puts "RUnning #{cmd}"
      `#{cmd}`
      raise "Error in '#{cmd}' " unless $? == 0
    end

    after(:all) do
      cmd = "aws s3 rm  s3://#{property[:Parameters][:BucketName]}/#{test_file}"
      `#{cmd}`
      raise "Error in '#{cmd}' " unless $? == 0
    end
    

    describe "Can cp S3 bucket object" do 

      describe command("aws s3 cp s3://#{property[:Parameters][:BucketName]}/#{test_file} /tmp/#{test_file} --region $(aws s3api get-bucket-location --bucket #{property[:Parameters][:BucketName]} --output text)") do
        its( :exit_status ) { should eq 0 }
      end

    end

  end # test_file in bucket

end

# ------------------------------------------------------------------
# 

context "When bucket does not exists" do 

  describe "Cannot list S3 bucket keys " do 
    describe command( "aws s3 ls s3://#{property[:Parameters][:BucketName]}2 --region $(aws s3api get-bucket-location --bucket #{property[:Parameters][:BucketName]} --output text)") do
      its( :exit_status ) { should_not eq 0 }
    end
  end

end



