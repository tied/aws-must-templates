# -*- coding: utf-8 -*-
# spec_helper for unit tests

require 'aws-must'


def stubbaa( yaml_text  )

  yaml = YAML.load(yaml_text)

  yaml_file = "tmp/koex.yaml"

  expect( YAML ).to receive(:load_file).with(yaml_file).and_return(yaml)
  allow( File ).to receive( :exist? ).with(yaml_file).and_return( true )

  return yaml_file
  
end
