require 'aws-sdk'
require 'serverspec'



module Serverspec
  module Type

    class VpcResource < Base

      def initialize( vpcName )
        raise "must set a 'vpcName' " unless vpcName
        @vpcName = vpcName
      end

      def to_s
        "vpc: '#{@vpcName}'"
      end

      def is_default?
        return describe_vpc.is_default
      end

      # convinience routine to check value of state
      def is_available?
        return state == "available"
      end

      # String, one of "pending", "available"
      def state
        return describe_vpc.state
      end
      
      private

      def client
        @ec2Client = Aws::EC2::Client.new
        return @ec2Client
      end

      def describe_vpc
        vpcs = describe_vpcs
        # vpc tagged `Name`== @vpcName
        vpc = vpcs.vpcs.select {|vpc| vpc.tags.select{ |tag| tag['key'] == 'Name' && tag['value'] == @vpcName }.any? }.first
        raise "No vpc tagged 'Name'='#{@vpcName}'" if vpc.nil?
        return vpc
      end
      
      # read all vpc
      def describe_vpcs
        options = {
          dry_run: false,
        }
        client.describe_vpcs( options )
      end


    end # class Vpc < Base

    def vpc_resource_by_name( vpcName )
      VpcResource.new( vpcName )
    end


  end # module Type
end

include Serverspec::Type

