=begin

+++start+++

## <a id="S3ReadAccessAllowed"></a>S3ReadAccessAllowed<a class='navigator' href='#top'>[top]</a>

Validate that read access to S3 bucket `test_parameter( current_test, "Bucket" )` exists

+++close+++

=end

# +++fold-on+++


require 'spec_helper'

current_test = "S3ReadAccessAllowed"

describe current_test do

  # ------------------------------------------------------------------
  # test parameters

  bucket_name = test_parameter( current_test, "Bucket" )

  # bucket_name =  stack_output( 'Bucket' ).value 

  # ------------------------------------------------------------------
  # constanst used in test

  test_file="ttest.tmp"

  # ------------------------------------------------------------------
  # Test paramters defined

  describe "Test parameter definition" do

    describe bucket_name do
      its( :definition_in_test_suite ) { should_not  eq nil }
    end

  end

  describe "Test parameter values" do

    describe bucket_name do
      its( :value ) { should_not  eq nil }
    end

  end


  # # ------------------------------------------------------------------
  # # Stack parameters && outputs

  # describe "Stack" do 

  #   it "#defines bucket_name"  do
  #     expect( bucket_name ).not_to eql( nil )
  #   end

  # end

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
      default_ls = "aws s3 ls s3://#{bucket_name.value}"
      region_ls  = "aws s3 ls s3://#{bucket_name.value} --region $(aws s3api get-bucket-location --bucket #{bucket_name.value} --output text)"
      describe command( "#{default_ls} || #{region_ls}" ) do
        its ( :exit_status ) { should eq 0 }
      end
    end


    context "When an Object exists in S3 bucket" do 

      before(:context) do
        cmd =  "echo tst | aws s3 cp - s3://#{bucket_name.value}/#{test_file}"
        `#{cmd}`
        raise "Error in '#{cmd}' " unless $? == 0
      end

      after(:context) do
        cmd = "aws s3 rm  s3://#{bucket_name.value}/#{test_file}"
        `#{cmd}`
        raise "Error in '#{cmd}' " unless $? == 0
      end

      # Using "serverspec" style here
      describe "Can read the Object from a S3 bucket" do 
        default_cp = "aws s3 cp s3://#{bucket_name.value}/#{test_file} /tmp/#{test_file}"
        region_cp = "aws s3 cp s3://#{bucket_name.value}/#{test_file} /tmp/#{test_file} --region $(aws s3api get-bucket-location --bucket #{bucket_name.value} --output text)"
        describe command( "#{default_cp} || #{region_cp}" ) do
          its( :exit_status ) { should eq 0 }
        end

      end

      # using subject + expect style
      describe "Cannot modify (= delete) the  Object in bucket" do

        describe  command("aws s3 rm s3://#{bucket_name.value}/#{test_file} --region $(aws s3api get-bucket-location --bucket #{bucket_name.value} --output text)") do
          its ( :exit_status )  { should_not eql 0 }
        end

      end

    end # context test_file in bucket

    # subject + it is_expected one liner
    describe "Cannot write to bucket" do 

      describe "Create an Object in bucket should fail" do
        describe command("aws s3 cp /etc/hosts  s3://#{bucket_name.value}/#{test_file} --region $(aws s3api get-bucket-location --bucket #{bucket_name.value} --output text)") do
          its( :exit_status ) { should_not eql 0  }
        end
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

# +++fold-off+++
