require 'aws-sdk'
require 'serverspec'


require_relative "./mixin_cidr"


module Serverspec
  module Type

    class Ec2Resource < Base

      def initialize( instanceId, attribute=nil )
        raise 'must set a instanceId' if instanceId.nil?
        @instanceId = instanceId
        # parameter `attribute` controls output in `to_s`
        @attribute  = attribute
      end

      def to_s
        "ec2: '#{@instanceId}'" + (@attribute ? ", #{@attribute}: #{self.send( @attribute )}"  :"" )
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

      def public_ip_address
        describe_instance.public_ip_address
      end

      def private_ip_address
        describe_instance.private_ip_address
      end

      # true if private_ip belongs to cidr
      def private_ip_address_valid_cidr?( cidr )
        private_ip = describe_instance.private_ip_address
        cidr_valid_ip( private_ip, cidr )
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

      def describe_instance
        describe_instances.reservations.first.instances.first
      end
      
      def describe_instances
        options = {
          dry_run: false,
          instance_ids: [ @instanceId ]
        }
        client.describe_instances( options )
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

      # valid
      include Serverspec::Type::CIDR

    end # class Vpc < Base

    def ec2_resource( instanceId )
      Ec2Resource.new( instanceId.kind_of?(Serverspec::Type::ValidProperty) ? instanceId.value : instanceId )
    end

    # resource output includes also attribute value
    def ec2_resource_attribute( instanceId, attribute )
      Ec2Resource.new( instanceId.kind_of?(Serverspec::Type::ValidProperty) ? instanceId.value : instanceId,
                       attribute.kind_of?(Serverspec::Type::ValidProperty) ? attribute.value : attribute
                       )
    end


  end # module Type
end

include Serverspec::Type

