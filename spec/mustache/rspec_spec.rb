require_relative "spec_helper"

describe "rspec" do

  it "#works" do
    expect( 1 ).to eql( 1 )
  end 

  # describe "AwsMust::AwsMust" do


  #   before :each do
  #     # @aws_must = AwsMust::AwsMust.new( {:log=>"DEBUG", :template_path => "mustache"} )
  #     @aws_must = AwsMust::AwsMust.new( { :template_path => "mustache"} )
  #   end

  #   it "#can create object 'AwsMust::AwsMust.new'" do
  #     expect( @aws_must ).not_to eql( nil )
  #   end 

  #   it "#responds to  'generate'" do
  #     expect( @aws_must ).to respond_to( :generate )
  #   end 

        
  # end

end # 
