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

      def self.new_for_ec2( instanceName )
        raise "must set a 'instanceName' " unless instanceName

        awsRoute = AwsRoute.new
        awsRoute.instanceName = instanceName
        return awsRoute
      end

      def initialize
      end

      # ------------------------------------------------------------------
      # public interface

      def to_s
        "awsRoute: " + 
          ( @instanceName ? " instanceName=#{@instanceName}" : "" )
      end


      def subnet_routes
        subnetId = describe_instance.subnet_id
        subnet_routes_as_array_of_hashes( subnetId )
      end


      private

      # ------------------------------------------------------------------
      # mixin interface

      def client
        @ec2Client = Aws::EC2::Client.new
        return @ec2Client
      end

      def get_instanceId
        return @instanceId if @instanceId 
        options = {
          dry_run: false,
          filters: [
                    { name: "tag:Name", values: [ instanceName  ]},
                    { name: "instance-state-name", values: [ "running"  ]},
                   ],
        }

        @instanceId = describe_instances(options).reservations.first.instances.first.instance_id
        return @instanceId
      end

      # ------------------------------------------------------------------
      # mixin services included

      include AwsMustTemplates::Mixin::EC2
      include AwsMustTemplates::Mixin::Subnet

    end # class Vpc < Base

    def route_resource_for_ec2( instanceName )
      AwsRoute.new_for_ec2( instanceName.kind_of?(Serverspec::Type::ValidProperty) ? instanceName.value : instanceName  )
    end


  end # module Type
end

include Serverspec::Type

