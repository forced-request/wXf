class WebXploit < WXf::WXfmod_Factory::Auxiliary

  include WXf::WXfassists::General::SavonReq
  
  def initialize
       super(
       

    'Name'        => 'SOAP REQUEST',
    'Version'     => '1.0',
    'Description' => %q{
     This forms a single soap request in the appropriate envelope.
                        },
    'References'  =>
     [
        [ 'URL', 'N/A' ],
     ],
    'Author'      => [ 'CKTRICKY' ],
    'License'     => WXF_LICENSE

      
       )
         
       
       
       init_opts([ 
        OptString.new('USER',     [false, "Specify a username", '']),
        OptString.new('PASS',     [false, "Specify a password",'']),
        OptString.new('PARAM' ,   [true, "The parameter which corresponds to the action", '']),
        OptString.new('VALUE' ,   [true, "Value to assign the parameter within the SOAP envelope", '']),
        OptString.new('RACTION',  [true, "Remote Action. Ex: GetUserID", '']),
        ])
       
       
   end
   
   def run
     
    single_action_req({
 
    'RURL'       => rurl,
    'PASS'       => datahash['PASS'],
    'USER'       => datahash['USER'],
    'PROXYP'     => proxyp,
    'PROXYA'    =>  proxya, 
    'RACTION'   =>  datahash['RACTION'],
    'RPARAMS'   => {datahash['PARAM'] => datahash['VALUE']},
    #'HEADERS'   => {"Testy" => "McTesterton"} 
     
})
    rescue => $!
     prnt_err(" #{$!}")
   end
 end
   
  
  
