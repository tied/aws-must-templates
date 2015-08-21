# -*- coding: utf-8 -*-
# spec_helper for unit tests

require 'aws-must'


def stub_yaml_file( yaml_text  )

  yaml = YAML.load(yaml_text)

  yaml_file = "tmp/koex.yaml"

  expect( YAML ).to receive(:load_file).with(yaml_file).and_return(yaml)
  allow( File ).to receive( :exist? ).with(yaml_file).and_return( true )

  return yaml_file
  
end

def json_sanitize( str, key='"val"' ) 
  return JSON.parse( "{ #{key} #{ key ? ':' : ''} #{str} }" )
end

def json_parse( str  ) 
  return JSON.parse( str )
end

# ------------------------------------------------------------------
# Fixed values

CONSTANT_MAPPINGS=<<-EOS
    "AWSInstanceType2Arch":{"t2.micro":{"Arch":"64"}}, "AWSRegionArch2AMI":{"ap-northeast-1":{"64":"ami-90815290"}, "ap-southeast-1":{"64":"ami-0accf458"}, "ap-southeast-2":{"64":"ami-1dc8b127"}, "cn-north-1":{"64":"ami-eae27fd3"}, "eu-central-1":{"64":"ami-3248712f"}, "eu-west-1":{"64":"ami-d74437a0"}, "sa-east-1":{"64":"ami-0f6ced12"}, "us-east-1":{"64":"ami-83c525e8"}, "us-west-1":{"64":"ami-61b25925"}, "us-gov-west-1":{"64":"ami-51513172"}, "us-west-2":{"64":"ami-57e8d767"}}
    EOS



