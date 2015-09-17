module AwsMustTemplates
  module Mixin
    module EC2

      # hash for aws ec2 sdk query
      def instance_query_options

        instanceId = get_instanceId

        options = {
          dry_run: false,
          instance_ids: [ instanceId ]
        }

        return options

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

      def describe_instance
        describe_instances.reservations.first.instances.first
      end
      
      def describe_instances( options = nil )
        options = instance_query_options if options.nil?
        client.describe_instances( options )
      end
      
      def describe_instance_status
        options = instance_query_options
        # puts "options=#{options}"
        resp =  client.describe_instance_status(options)
        return resp.instance_statuses.first
      end

      def describe_instance_attribute( attribute )
        # options = instance_query_options
        # options[:attribute] = attribute
        instanceId = get_instanceId
        options = {
          dry_run: false,
          instance_id:  instanceId,
          attribute: attribute
        }
        client.describe_instance_attribute(options)
      end


    end
  end
end
