require 'aws-sdk'
require 'serverspec'



module Serverspec
  module Type
    class AwsRoute < Base

      # ------------------------------------------------------------------
      # attrbutes
      
      attr_accessor :instanceName     # tagged


      # ------------------------------------------------------------------
      # constrcutore


      def new_for_ec2( instanceName )
        raise "must set a 'instanceName' " unless instanceName

        awsRoute = AwsRoute.new
        ec2.instanceName = instanceName
        return awsRoute
      end

      def initialize(  )
        @vpcName = vpcName
      end

      # ------------------------------------------------------------------
      # public interface

      def to_s
        "awsRoute: " + 
          ( @instanceName ? " instanceName=#{@instanceName}" : "" )
      end

      # ------------------------------------------------------------------
      # private 

      private

      def client
        @ec2Client = Aws::EC2::Client.new
        return @ec2Client
      end

      # describe_instances etc.
      include AwsMustTemplates::Mixin::EC2

    end # class Vpc < Base

    def route_resource_for_ec2( instanceName )
      AwsRoute.new_for_ec2( instanceName )
    end


  end # module Type
end

include Serverspec::Type

