#!/usr/bin/env ruby
# 
# Created Oct 27 2010
#

class WebXploit < WXf::WXfmod_Factory::Auxiliary
  
  include WXf::WXfassists::General::MechReq

  
  def initialize
      super(
       'Name'        => 'Single Mechanize Request',
       'Version'     => '1.0',
       'Description' => %q{
        Sends a single mechanize request
                        },
       'References'  =>
        [
        
        ],
       'Author'      => [ 'CKTRICKY' ],
       'License'     => WXF_LICENSE
      )
      
      init_opts([
       OptString.new('UA', [true, "Specify a user agent to utilize", "Mozilla"]),
       OptBool.new('REDIRECT', [false, "If set to false, a 302 redirection will not be followed" , true]),
      ])
      
  end
  

  def run
  res = send_request_cgi({
  'method'     => 'GET',
  'RURL'       => rurl,
  'DEBUG'      => 'yes',
  'UA'         => datahash['UA'],
  'PROXY_ADDR' => proxya,
  'PROXY_PORT' => proxyp,
  'REDIRECT'   => datahash['REDIRECT'],
  })
  
  if (res) and (res.respond_to?('code')) and (res.code == '200')
    question = prnt_plus("Would you like to see the body? [y/n]")
    answer = gets.chomp
    if answer == 'y'
    print_status('-----------------------------------------------------------')
    print_status('-----------------------------------------------------------')
    print_status('-----------------------BODY--------------------------------')
    prnt_plus("\n\n"+ green("#{res.body}"))
    output("#{res.body}", "sreqlog", "xml")
    else
    end
  end
end



end
  