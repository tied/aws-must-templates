=begin

+++start+++

## <a id="S3NoAccess"></a>S3NoAccess<a class='navigator' href='#top'>[top]</a>

Validate no access to S3 bucket `test_parameter( current_test, "Bucket" )`

+++close+++

=end

# +++fold-on+++

require 'spec_helper'

# ------------------------------------------------------------------
# config

current_test = "S3NoAccess"

# ------------------------------------------------------------------
# Tests

describe current_test  do 

  # ------------------------------------------------------------------
  # test parameters

  bucket_name = test_parameter( current_test, "Bucket" )

  # ------------------------------------------------------------------
  # Context NO access granted

  context "When Bucket exists" do 

    before(:all) do
      cmd =  "aws s3 ls s3://#{bucket_name.value}"
      `#{cmd}`
      raise "Error in '#{cmd}' " unless $? == 0
    end

    describe "#cannot  list Bucket" do 
      describe command('aws s3 ls') do
        its( :exit_status ) { should_not eq 0 }
      end
    end

    test_file="ttest22.tmp"


    context "When Object exists in Bucket" do 

      # File copy succeed --> bucket exists
      before() do
        cmd =  "echo tst | aws s3 cp - s3://#{bucket_name.value}/#{test_file}"
        `#{cmd}`
        raise "Error in '#{cmd}' " unless $? == 0
      end

      after(:all) do
        cmd = "aws s3 rm  s3://#{bucket_name.value}/#{test_file}"
        `#{cmd}`
        raise "Error in '#{cmd}' " unless $? == 0
      end

      describe "#cannot list S3 bucket keys" do 
        describe command( "aws s3 ls s3://#{bucket_name.value} --region $(aws s3api get-bucket-location --bucket #{bucket_name.value} --output text)") do
          its( :exit_status ) { should_not eq 0 }
        end
      end

      describe "#cannot cp S3 bucket object" do 
        describe command("aws s3 cp s3://#{bucket_name.value}/#{test_file} /tmp/#{test_file} --region $(aws s3api get-bucket-location --bucket #{bucket_name.value} --output text)") do
          its( :exit_status ) { should_not eq 0 }
        end
      end

    end # conttext

  end

end


# +++fold-off+++
