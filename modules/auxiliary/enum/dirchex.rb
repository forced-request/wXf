#!/usr/bin/env ruby
# 
# Created Oct 11 2010
#

class WebXploit < WXf::WXfmod_Factory::Auxiliary

 include WXf::WXfassists::General::MechReq
 include WXf::WXfassists::Auxiliary::MultiHosts   
  
  def initialize
      super(
        'Name'        => 'DIRCHEX',
        'Version'     => '1.0',
        'Description' => %q{
          Command line version of the program DirChex by k3r0s1n3.                        },
        'References'  =>
        [
          [ 'URL', 'http://code.google.com/p/dirchex/' ],
        ],
        'Author'      => [ 'k3r0s1n3' ],
        'License'     => WXF_LICENSE

      )
   
      init_opts([
        OptString.new('METHOD', [true, "Enter either GET or PUT HTTP Methods", "GET"]),
        OptString.new('UA',     [true, "Please enter a User Agent", "1" ]),
        OptString.new('CONTENTTYPE', [false, "Enter a content-type, ONLY if using PUT method", "1"]),
        OptString.new('PUTFILE', [false, "Enter the name of the file to PUT (only if using PUT)", "test_file"]),
        OptString.new('FILECONTENT', [false, "Enter text to put into the file (only is using PUT)", "test text within test_file"]),
      ])
  
  end
  
  def run
    dradis = WXf::WXflog::DradisLog.new({
      'Filename' => "dirchex.xml",
      'Name'     => "DirChex Out"
    })
   
    
    # Beginning of the loop
    rurls.each do |rurl| 
      res = nil 
       case datahash['METHOD']
         when "GET"
          res = mech_req({
            'method' => "GET",
            'UA' => datahash['UA'],
            'RURL'=> rurl,
            'DEBUG'      => 'log'
          })
         when "PUT"           
           res = mech_req({
             'method'       => "PUT",
             'UA'           => datahash['UA'],
             'RURL'         => rurl,
             'RFILE'        => datahash['PUTFILE'],
             'RFILECONTENT' => datahash['FILECONTENT'],
             'DEBUG'        => 'log',
             'RPARAMS'       => {'Content-Type' => datahash['CONTENTTYPE']}               
          })
         else
          prnt_err("Only use GET or PUT methods") 
          return
       end
     
             
     if (rce) and (rce_code)
       header_hash = {'URL' => "#{rurl}"}          
       dradis.add_ritems([header_hash, "#{rce_code}", "#{rce}"])
     end
      

      
      if (res) and (res.respond_to?('code'))
        dradis.add_ritems([res.header, req_seq , res.body])
      end
    
    end #End of the outer loop
    dradis.log
  end
  
end
