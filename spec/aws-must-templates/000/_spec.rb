=begin

First file in directory listing. 

==================================================================
STYLE section
==================================================================

+++start+++

<style>
h1 {
    color:blue; 
    font-size: 2.5em;
   }
h2 {
      color:blue;
      font-size: 1.5em;
   }
h3 {
      color:blue;
      font-size: 1.5em;
   }
.navigator {
      font-size: 0.5em;
   }
body {
    background-color: LightSlateGray;
} 
/* Support fold-on/fold-off toggle */
div.fold { 
    width: 90%; padding: .42rem; border-radius: 5px;  margin: 1rem; 

}
div.fold div { 
       height: 0px; margin: .2rem; overflow: hidden; 
}
div.toggle ~ div { height: 0px; margin: .2rem; overflow: hidden; }
input.toggle:checked ~ div { 
     height: auto;      
     color: white; 
     background: #c6a24b;
     font-family: monospace;
     white-space: pre; 
}
</style>
+++close+++



=end

=begin

==================================================================
CONTENT section
==================================================================

+++start+++

# <a id="top"/><a href="https://github.com/jarjuk/aws-must-templates">aws-must-templates</a>

RSPEC -tests for `aws-must-templates`.

## Table of contents

<ul>
    <li>Resuable tests:</li>
    <ul>
       <li><a href="#AwsCommandLineInterfaceInstalled">AwsCommandLineInterfaceInstalled</a></li>
       <li><a href="#CloudFormationHelperScriptsInstalled">CloudFormationHelperScriptsInstalled</a></li>
       <li><a href="#RespondsToPing">RespondsToPing</a>: Responds to ping</li>
       <li><a href="#S3NoAccess">S3NoAccess</a></li>
       <li><a href="#S3ReadAccessAllowed">S3ReadAccessAllowed</a></li>
       <li><a href="#ValidOSVersion">ValidOSVersion</a></li>
    </ul> 

    <li>Development:</li>
    <ul> 
       <li><a href="#AwsMustTestRunnerProperties">AwsMustTestRunnerProperties</a></li>
       <li><a href="#ParameterTest">ParameterTest</a></li>
       <li><a href="#Stack">Stack</a></li>
    </ul> 

</ul>

+++close++++
=end
