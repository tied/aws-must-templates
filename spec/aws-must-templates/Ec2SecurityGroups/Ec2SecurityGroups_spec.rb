=begin

+++start+++

## <a id="Ec2SecurityGroups"></a>Ec2SecurityGroups<a class='navigator' href='#top'>[top]</a>

Validates EC2 security group ingress/egress rules. A 

**Parameters**

* `instance = suite_value( :instance_name )` : name of instance being tested
* `ingress = test_parameter( current_test, "Ingress" )` : ingress on
  the EC2 instance to validate
* `egress = test_parameter( current_test, "Egress" )`: egress rules on
  the EC2 instance to validate
* `strictIngress = test_parameter( current_test, "StrictIngress",
  false )`: validate exactly |Ingress| rules
* `strictEgress = test_parameter( current_test, "StrictEgress", false )`: 
   validate exactly |Egress| rules
   

             - Ec2SecurityGroups:
                 StrictIngress: false
                 StrictEgress: false
                 Ingress:
				      # ping response only in local subnet
                    - :ip_protocol: icmp
                      :from_port: -1
                      :to_port: -1
                      :ip_ranges:
                         - :cidr_ip: *SubNetPrivate
                 Egress:
                      # allow ping Internet
                    - :ip_protocol: icmp
                      :from_port: -1
                      :to_port: -1
                      :ip_ranges:
                         - :cidr_ip: "0.0.0.0/0"

+++close+++

=end

# +++fold-on+++

require 'spec_helper'

current_test = File.basename File.dirname  __FILE__ 

# ------------------------------------------------------------------
# Use custom matcher to loop array of rules and validate that expected
# rule is "included" to one of these rules.

RSpec::Matchers.define :define_rule do |expected|

  match do |actual_rules|
    
    result = false

    actual_rules.each do |rule|
      # puts "rule=#{rule} vs. #{expected}"
      begin 
        result |= expect( rule ).to include( expected )
        break if result
      rescue Exception => e
        # puts "Rescued #{e}"
      end
    end
    return result
    # actual % expected == 0
  end

  failure_message do |actual_rules|
    "rule #{expected} was not included in actual rules #{actual_rules}  "
  end
end

describe current_test do

  # ------------------------------------------------------------------
  # test parameters

  instance = suite_value( :instance_name ) 
  ingress = test_parameter( current_test, "Ingress" )
  egress = test_parameter( current_test, "Egress" )
  strictIngress = test_parameter( current_test, "StrictIngress", false )
  strictEgress = test_parameter( current_test, "StrictEgress", false )
  


  # ------------------------------------------------------------------
  # tests
  describe security_group_resource_for_ec2( instance ) do

    let( :implemented_ingress_rules ) {  subject.instance_ingress_rules() }
    let( :implemented_egress_rules ) {  subject.instance_egress_rules() }

    # ------------------------------------------------------------------
    # ingresss rules
    context "ingress rules" do

      if strictIngress.value then
        it "validate all ingress rules in test suite" do
          expect( implemented_ingress_rules.length ).to eql( ingress.value.length  )
        end
      else
        it "WARNING does not validate all ingress rules in test suite" do
          expect( ingress.value.length ).to eql( ingress.value.length )
        end
      end 

      # iterate 'expacted ingress' rules
      ingress && ingress.value && ingress.value.each do |expected_rule|
        # use to validate corresponding implemented route
        it "implement ingress rule: #{expected_rule}" do
          expect( implemented_ingress_rules ).to define_rule( expected_rule )
        end
      end

    end

    # ------------------------------------------------------------------
    # egress

    context "egress rules" do

      if strictEgress.value then
        it "validates all egress rules in test suite" do
          expect( implemented_egress_rules.length  ).to eql( egress.value.length )
        end
      else
        it "WARNING does not validate all egress rules in test suite" do
          expect( egress.value.length ).to eql( egress.value.length )
        end
      end
      

      # iterate 'expacted egress' rules
      egress && egress.value && egress.value.each do |expected_rule|
        # use to validate corresponding implemented route
        it "implement egress rule:  #{expected_rule}" do
          expect( implemented_egress_rules ).to define_rule( expected_rule )
        end
      end

    end

  end # instance
end

# +++fold-off+++
