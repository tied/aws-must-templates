require 'netaddr'

module AwsMustTemplates
  module Mixin
    module CIDR

      # true if `cidr` contains `ip`
      def cidr_valid_ip( ip, cidr )

        cird4 = NetAddr::CIDR.create( cidr )
        cird4.contains?( ip )
        
      end

    end  # module CIDR

  end # 
end 
