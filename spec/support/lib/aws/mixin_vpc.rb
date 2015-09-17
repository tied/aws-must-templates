module AwsMustTemplates
  module Mixin
    module Vpc
      def describe_vpc( vpcId ) 
        options = { vpc_ids: [ vpcId ] }
        client.describe_vpcs( options ).first
      end
    end
  end
end
