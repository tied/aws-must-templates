require 'spec_helper'

# ------------------------------------------------------------------
# config

expected_properties = [
                       ['Outputs', 'Bucket' ],
                      ]


# ------------------------------------------------------------------
# Tests

describe "S3NoAccess" do 

  # ------------------------------------------------------------------
  # Stack parameters && output

  describe "Stack parameters and outputs" do 

    expected_properties.each do | keys |
      describe valid_property( property, keys ) do
        its( :value ) { should_not eq nil } 
      end

    end

  end

  # ------------------------------------------------------------------
  # Context NO access granted

  context "When NO access to S3 bucket granted" do 
    
    describe "Cannot  list S3 buckets" do 
      describe command('aws s3 ls') do
        its( :exit_status ) { should_not eq 0 }
      end
    end


    test_file="ttest22.tmp"


    context "Object #{test_file} exists in bucket 's3://#{property['Outputs']['Bucket']}'" do 

      # File copy succeed --> bucket exists
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

      describe "Cannot list S3 bucket keys" do 
        describe command( "aws s3 ls s3://#{property['Outputs']['Bucket']} --region $(aws s3api get-bucket-location --bucket #{property['Outputs']['Bucket']} --output text)") do
          its( :exit_status ) { should_not eq 0 }
        end
      end

      describe "Cannot cp S3 bucket object" do 
        describe command("aws s3 cp s3://#{property['Outputs']['Bucket']}/#{test_file} /tmp/#{test_file} --region $(aws s3api get-bucket-location --bucket #{property['Outputs']['Bucket']} --output text)") do
          its( :exit_status ) { should_not eq 0 }
        end
      end


    end # conttext

  end




end
