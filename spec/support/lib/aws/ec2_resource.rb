require 'aws-sdk'
require 'serverspec'


module Serverspec
  module Type

    class Ec2Resource < Base

      def initialize( instanceId )
        raise 'must set a instanceId' if instanceId.nil?
        @instanceId = instanceId
      end

      def to_s
        "ec2: '#{@instanceId}'"
      end

      def availability_zone 
        describe_instance_status.availability_zone
      end

      def system_status_ok?
        return describe_instance_status.system_status.status == "ok"
      end

      def instance_state_running?
        return describe_instance_status.instance_state.name == "running"
      end

      def instance_type
        describe_instance_attribute("instanceType").instance_type.value
      end

      def instance_id
        # use 'instanceType'  return also instace_id
        describe_instance_attribute("instanceType").instance_id
      end

      private

      def client
        @ec2Client = Aws::EC2::Client.new
        return @ec2Client
      end

      
      def describe_instance_status
        options = {
          dry_run: false,
          instance_ids: [ @instanceId ]
        }

        resp =  client.describe_instance_status(options)
        return resp.instance_statuses.first
      end

      def describe_instance_attribute( attribute )
        options = {
          dry_run: false,
          instance_id:  @instanceId,
          attribute: attribute
        }

        client.describe_instance_attribute(options)
      end



    end # class Vpc < Base

    def ec2_resource( instanceId )
      Ec2Resource.new( instanceId.kind_of?(Serverspec::Type::ValidProperty) ? instanceId.value : instanceId )
    end

  end # module Type
end

include Serverspec::Type

