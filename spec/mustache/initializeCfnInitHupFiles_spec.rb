require_relative "spec_helper"

template_under_test = "initializeCfnInitHupFiles"

describe template_under_test do


  let( :template_dir ) { "mustache" }

  before :each do
    @aws_must = AwsMust::AwsMust.new( { :template_path => template_dir } )

    # hide partials
    allow_any_instance_of( AwsMust::Template ).to receive( :partial ).with( any_args ).and_return( "" )
    # verify that template_under_test actually used
    expect_any_instance_of( AwsMust::Template ).to receive( :get_template ).with( template_under_test  ).and_call_original

  end



  it "#default" do


    expect_str= <<-EOS

        "/etc/cfn/cfn-hup.conf":{
            "content":{
                "Fn::Join":["", [
                    "[main]\\n",
                    "stack=", {"Ref":"AWS::StackName"}, "\\n",
                    "credential-file=/etc/cfn/cfn-credentials\\n",
                    "interval=1\\n",
                    "region=", {"Ref":"AWS::Region"}, "\\n"
                ]]
            },
            "mode":"000400",
            "owner":"root",
            "group":"root"
        }
        
        ,  "/etc/cfn/cfn-credentials":{
            "content":{
                "Fn::Join":["", [
                    "AWSAccessKeyId=", {"Ref":"userKey"}, "\\n",
                    "AWSSecretKey=", {"Fn::GetAtt":["userKey", "SecretAccessKey"]}, "\\n"
                ]]
            },
            "mode":"000400",
            "owner":"root",
            "group":"root"
        }
        
        , "/etc/cfn/hooks.d/cfn-auto-reloader.conf":{
            "content":{
                "Fn::Join":["", [
                    "[cfn-auto-reloader-hook]\\n",
                    "triggers=post.update\\n",
                    "path=Resources.resource.Metadata.CfnHup\\n",
                    "action=action\\n",
                    "runas=root\\n"
                ]]
            }
        }
        
        , "action":{
            "content":{
                "Fn::Join":["", [ "script1\\n",
        "script2\\n",
                                  "\\n"
                            ]]
            },
            "mode":"000555",
            "owner":"root",
            "group":"root"
        
        }
    EOS

    
    yaml_text = <<-EOS
      CfnUserKey: userKey
      CfnResource: resource
      CfnAction: action
      CfnScript: 
          - script1
          - script2
    EOS

    # debug
    # puts "expect_str=#{expect_str}"
    # puts json_sanitize( expect_str, nil )

    render_str = @aws_must.generate_str( template_under_test, stub_yaml_file( yaml_text ), {} )

    # debug
    # puts "render_str=#{render_str}"
    # puts json_sanitize( render_str + dummy_element  )

    expect( json_sanitize( render_str, nil   )).to eql( json_sanitize( expect_str, nil  ))

  end


end
