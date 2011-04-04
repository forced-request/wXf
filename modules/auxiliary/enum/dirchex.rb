#!/usr/bin/env ruby
# 
# Created Oct 11 2010
#

class WebXploit < WXf::WXfmod_Factory::Auxiliary

  def initialize
      super(
        'Name'        => 'DIRCHEX',
        'Version'     => '1.0',
        'Description' => %q{
          Command line version of the program DirChex by k3r0s1n3 and cktricky.                        },
        'References'  =>
        [
          [ 'URL', 'http://code.google.com/p/dirchex/' ],
        ],
        'Author'      => [ 'CKTRICKY' ],
        'License'     => WXF_LICENSE

      )
   
      init_opts([
        OptString.new('METHOD', [true, "Enter either GET or PUT HTTP Methods", "GET"]),
        OptString.new('UA',     [true, "Please enter a User Agent", "Mozilla/5.0 (X11; Linux x86_64; rv:2.0b9pre) Gecko/20110111 Firefox/4.0b9pre" ]),
        OptString.new('CONTENTTYPE', [false, "Enter a content-type, ONLY if using PUT method", "application/javascript"]),
        OptString.new('PUTFILE', [false, "Enter the name of the file to PUT (only if using PUT)", "test_file"]),
        OptString.new('FILECONTENT', [false, "Enter text to put into the file (only is using PUT)", "test text within test_file"]),
        OptString.new('LFILE', [true, "Enter the local file to read from", ""])
      ])
  
  end
  
  def run
   
=begin    
    res = mech_req({
     'method' => datahash[''],
     'UA' => check,
     'RURL'=> rurl,
     'PROXY_ADDR' => proxya,
     'PROXY_PORT' => proxyp,
     'REDIRECT' => 'false',
               }                                                                 
             )
=end
  end
  
end
