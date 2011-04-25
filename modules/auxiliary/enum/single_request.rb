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
       OptString.new('CONTENT', [false, "Specify a content-type", ""]),
       OptBool.new('REDIRECT', [false, "If set to false, a 302 redirection will not be followed" , true]),
      ])
      
  end
  

  def run
    dradis = WXf::WXflog::DradisLog.new({
      'Name' => rurl,
      'Filename' => 'single_request.xml'
    })
    
    res = send_request_cgi({
    'method'     => 'GET',
    'RURL'       => rurl,
    'DEBUG'      => 'log',
    'UA'         => datahash['UA'],
    'PROXY_ADDR' => proxya,
    'PROXY_PORT' => proxyp,
    'REDIRECT'   => datahash['REDIRECT'],
    'KEEP-ALIVE' => 200,
    'HEADERS'    => {'Content-Type' => datahash['CONTENT']}
    })
  
    if (res) and (res.respond_to?('code')) and (res.code == '200')
      question = prnt_plus("Would you like to see the body? [y/n]")
      answer = gets.chomp
        if answer == 'y'
          print_status('-----------------------------------------------------------')
          print_status('-----------------------------------------------------------')
          print_status('-----------------------BODY--------------------------------')
          prnt_plus("\n\n"+ green("#{res.body}"))
       else
      end
    dradis.add_ritems([res.header, req_seq , res.body])
   end
    dradis.log
 end



end
  