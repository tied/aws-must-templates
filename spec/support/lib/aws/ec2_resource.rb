require 'aws-sdk'
require 'serverspec'


require_relative "./mixin_cidr"
require_relative "./mixin_subnet"
require_relative "./mixin_ec2"


module Serverspec
  module Type
    class Ec2Resource < Base

      # ------------------------------------------------------------------
      # attrbutes
      
      attr_accessor :instanceId       # 
      attr_accessor :instanceName     # tagged

      attr_accessor :attribute

      # ------------------------------------------------------------------
      # constrcutore

      def self.new_by_instanceName( instanceName, attribute=nil )

        raise 'must set a instanceName' if instanceName.nil?
        ec2 = Ec2Resource.new
        ec2.instanceName = instanceName
        ec2.attribute = attribute

        return ec2

      end

      def self.new_by_instanceId( instanceId, attribute=nil )

        raise 'must set a instanceId' if instanceId.nil?
        ec2 = Ec2Resource.new
        ec2.instanceId = instanceId
        ec2.attribute = attribute

        return ec2

      end

      def initialize( )
      end

      # ------------------------------------------------------------------
      # public interface

      def to_s
        "ec2:" +
          ( @instanceId ? " instanceId=#{@instanceId}" : "" ) + 
          ( @instanceName ? " instanceName=#{@instanceName}" : "" ) + 
          (@attribute ? ", #{@attribute}: #{self.send( @attribute )}"  :"" )
      end

      def availability_zone 
        describe_instance_status.availability_zone
      end

      def system_status_ok?
        return system_status == "ok"
      end

      def system_status_not_impaired?
        return system_status != "impaired"
      end

      def system_status
        return describe_instance_status.system_status.status
      end

      def instance_state_running?
        return instance_state.name == "running"
      end

      def instance_state
        return describe_instance_status.instance_state
      end

      def instance_type
        describe_instance_attribute("instanceType").instance_type.value
      end

      def public_ip_address
        describe_instance.public_ip_address
      end

      def subnet_id
        describe_instance.subnet_id
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

      # routes


      private

      # ------------------------------------------------------------------
      # mixin interface

      def client
        @ec2Client = Aws::EC2::Client.new
        return @ec2Client
      end

      # return @instanceId or read it using aws sdk
      def get_instanceId
        return @instanceId if @instanceId 
        options = {
          dry_run: false,
          filters: [
                    { name: "tag:Name", values: [ @instanceName  ]},
                    { name: "instance-state-name", values: [ "running"  ]},
                   ],
        }

        @instanceId = describe_instances(options).reservations.first.instances.first.instance_id
        return @instanceId
      end

      # ------------------------------------------------------------------
      # mixin services included

      include AwsMustTemplates::Mixin::CIDR
      include AwsMustTemplates::Mixin::EC2

    end # class Vpc < Base

    # ------------------------------------------------------------------
    # serverspec resource

    def ec2_resource( instanceId )
      Ec2Resource.new_by_instanceId( instanceId.kind_of?(Serverspec::Type::ValidProperty) ? instanceId.value : instanceId )
    end

    def ec2_named_resource( instanceName )
      Ec2Resource.new_by_instanceName( instanceName.kind_of?(Serverspec::Type::ValidProperty) ? instanceName.value : instanceName )
    end

    # resource output includes also attribute value
    def ec2_resource_attribute( instanceId, attribute )
      Ec2Resource.new_by_instanceId( instanceId.kind_of?(Serverspec::Type::ValidProperty) ? instanceId.value : instanceId,
                       attribute.kind_of?(Serverspec::Type::ValidProperty) ? attribute.value : attribute
                       )
    end

    def ec2_named_resource_attribute( instanceName, attribute )
      Ec2Resource.new_by_instanceName( instanceName.kind_of?(Serverspec::Type::ValidProperty) ? instanceName.value : instanceName,
                       attribute.kind_of?(Serverspec::Type::ValidProperty) ? attribute.value : attribute
                       )
    end



  end # module Type
end

include Serverspec::Type

