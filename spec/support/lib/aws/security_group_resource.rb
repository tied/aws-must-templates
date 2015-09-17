require 'aws-sdk'
require 'serverspec'

require_relative "./mixin_security_group"

module Serverspec
  module Type
    class SecurityGroup < Base

      # ------------------------------------------------------------------
      # attrbutes
      
      attr_accessor :instanceName     # ec2 tagged with 'Name' = @instanceName


      # ------------------------------------------------------------------
      # constrcutore

      def self.new_for_ec2( instanceName )
        raise "must set a 'instanceName' " unless instanceName

        sg = SecurityGroup.new
        sg.instanceName = instanceName
        return sg
      end

      def initialize
      end

      # ------------------------------------------------------------------
      # public interface

      def to_s
        "Security group: " + 
          ( @instanceName ? " instanceName=#{@instanceName}" : "" )
      end

      # http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html#security-group-rules
      #  Security group rules are always permissive; you can't create
      #  rules that deny access.
      def instance_ingress_rules
        instance_security_group_ip_permissions
      end

      def instance_egress_rules
        instance_security_group_ip_permissions_egress
      end

      private

      # collect all ingress permissions to an array
      def instance_security_group_ip_permissions
        ret = [];
        describe_security_groups(instance_security_group_ids).
          inject( ret ){ |ret,group| 
          group.ip_permissions.each{ |ip_permission| ret << ip_permission.to_h  }}
        return ret
      end

      # collect all egress permissions to an array
      def instance_security_group_ip_permissions_egress
        ret = [];
        describe_security_groups(instance_security_group_ids).
          inject( ret ){ |ret,group| 
          group.ip_permissions_egress.each{ |ip_permission_egress| ret << ip_permission_egress.to_h  }}
        return ret
      end


      # security group ids for an instance
      def instance_security_group_ids
        instance_security_groups.map{ |group| group.group_id }
      end


      # for an instance
      def instance_security_groups
        describe_instance.security_groups
      end


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
      include AwsMustTemplates::Mixin::SecurityGroup

    end # class Vpc < Base

    def security_group_resource_for_ec2( instanceName )
      SecurityGroup.new_for_ec2( instanceName.kind_of?(Serverspec::Type::ValidProperty) ? instanceName.value : instanceName  )
    end

  end # module Type
end

include Serverspec::Type

