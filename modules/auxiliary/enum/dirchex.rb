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
     COMING SOON WE PROMISE!
                        },
    'References'  =>
     [
        [ 'URL', 'http://code.google.com/p/dirchex/' ],
     ],
    'Author'      => [ 'CKTRICKY' ],
    'License'     => WXF_LICENSE

        
      )
        
  
  end
  
  def run
    
    prnt_dbg(" Coming Soon")
    
  end
  
end
