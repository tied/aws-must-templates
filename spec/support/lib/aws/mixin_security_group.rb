module AwsMustTemplates
  module Mixin
    module SecurityGroup

      private

      # access subnet by 'subnetId'
      def describe_security_groups( securityGroupIds )
        options = { group_ids: securityGroupIds }
        client.describe_security_groups( options ).security_groups
      end

    end
  end
end
