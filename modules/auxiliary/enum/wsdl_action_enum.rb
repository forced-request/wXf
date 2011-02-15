class WebXploit < WXf::WXfmod_Factory::Auxiliary

  include WXf::WXfassists::General::SavonReq
  
  def initialize
       super(
       

    'Name'        => 'WSDL ACTIONS ENUMERATOR MODULE',
    'Version'     => '$Revision:$',
    'Description' => %q{
     This scans a WSDL file for available actions. Provide a URL to the reference.
                        },
    'References'  =>
     [
        [ 'URL', 'N/A' ],
     ],
    'Author'      => [ 'CKTRICKY' ],
    'License'     => WXF_LICENSE

      
       )
         
       
       
       init_opts([
        OptString.new('USER', [false, "Specify a username", '']),
        OptString.new('PASS', [false, "Specify a password", '']),
        ])
       
       
   end
   
   def run
     user = datahash['USER']
     pass = datahash['PASS']
       
       
     client =  simple_savon_client({
     'RURL'       => rurl,
   
})
      
     client.request.basic_auth("#{user}", "#{pass}")
   
     
     if (client.respond_to?('wsdl')) and (client.wsdl.respond_to?('soap_actions'))
       
       prnt_plus(" The following action(s) are included in the WSDL Provided:" + "\n")
       
       client.wsdl.soap_actions.each {|action|
         
         print_single(" #{action}" + "\n")
          
       }
       
     end
     
    rescue => $!
      
     prnt_err(" #{$!}")
       
       
   end
 end
   
  
  
