module Serverspec
  module Type
    module Subnet

      private

      #  'nil' if  no route-tables for subnet
      def subnet_routes_as_array_of_hashes( subnetId )

        # Each subnet must be associated with a route table, which
        # controls the routing for the subnet. If you don't explicitly
        # associate a subnet with a particular route table, the subnet uses
        # the main route table.

        routes = subnet_routes_from_subnet( subnetId )
        routes = subnet_routes_from_vpc( subnetId ) if routes.nil?

        # map to hash
        return routes.inject([]){ |arr,r| arr << r.to_h }

      end

      def subnet_routes_from_subnet( subnetId )
        route_tables = describe_route_tables_for_subnet( subnetId ).route_tables
        return nil unless route_tables.any?
        return route_tables.first.routes
      end

      # access main route table on vpc
      def subnet_routes_from_vpc( subnetId )
        subnet = describe_subnet( subnetId )
        route_tables = describe_route_tables_for_vpc( subnet.vpc_id  ).route_tables
        return route_tables.first.routes
      end


      # access subnet by 'subnetId'
      def describe_subnet( subnetId )
        options = { subnet_ids: [ subnetId ] }
        client.describe_subnets( options ).subnets.first
      end

      # aws client request for route tables associated with subnet
      def describe_route_tables_for_subnet( subnetId )
        options = {
          dry_run: false,
          route_table_ids: nil,
          filters: [
                    {
                      name: "association.subnet-id",
                      values: [ subnetId ],
                    }
                   ]
        }
        client.describe_route_tables( options )
      end

      # aws client request for route tables associated with 'vpcId'
      def describe_route_tables_for_vpc( vpcId )
        options = {
          dry_run: false,
          route_table_ids: nil,
          filters: [
                    {
                      name: "vpc-id",
                      values: [ vpcId ],
                    }
                   ]
        }
        client.describe_route_tables( options )
      end



    end
  end
end
