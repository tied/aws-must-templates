=begin

+++start+++

## <a id="Ec2Routes"></a>Ec2Routes<a class='navigator' href='#top'>[top]</a>

Validates that routes in EC2 `InstanceId`

**Parameters**

* `instance = suite_value( :instance_id )` : name of instance being tested
* `test_parameter( current_test, "Routes" )` : and array of route definitions

For example: Validata that 'Instance1' in output section defines two
routes. Fist route forwards VPC traffic to 'local' gateway, and
default route forwards to internet gateway (matched using regexp).


     - Ec2Routes:
          Routes:   
              - :destination_cidr_block: 10.0.0.0/16
                :gateway_id: local
                :state: active
              - :destination_cidr_block: "0.0.0.0/0"
                :gateway_id: !ruby/regexp '/^ig.*/'
                :state: active

+++close+++

=end

# +++fold-on+++

require 'spec_helper'

current_test = File.basename File.dirname  __FILE__ 

describe current_test do

  # ------------------------------------------------------------------
  # test parameters

  instance = suite_value( :instance_id )
  routes = test_parameter( current_test, "Routes" )

  # ------------------------------------------------------------------
  # tests

  describe route_resource_for_ec2( instance ) do

    let( :implemented_routes ) {  subject.subnet_routes() }

    # iterate 'expacted routes'
    routes.value.each_with_index do |expected_route,i|

      # use to validate corresponding implemented route
      it "implement route #{expected_route}" do
        expect( implemented_routes[i] ).to include( expected_route )
      end

    end # iterate expections

    
  end # instance


end

# +++fold-off+++
