

class WebXploit < WXf::WXfmod_Factory::Buby 
    
  module Runner   
   
      def evt_proxy_message(*param)
         msg_ref, is_req, rhost, rport, is_https, http_meth, url, resourceType, status, req_content_type, message, action = param
           if not rhost == "#{$datahash['RHOST']}"
             action[0] = 2
           end      
       super(*param)       
      end
    
  end 
    
  
  def initialize
    super(

            'Name'        => 'Dont Intercept',
            'Description' => %q{
             All requests to hosts EXCEPT the target RHOST will automatically bypass interception via the proxy.
            },
            'References'  =>
             [               
             ],
            'Author'      => [ 'CKTRICKY',],
            'License'     => WXF_LICENSE
  
    )
    
    init_opts([
      OptString.new('RHOST', [true, "Enter the remote host value", "www.example.com"])           
    ])
  end

  
  def run
   $datahash = datahash 
   if $burp
     $burp.extend(Runner)
     prnt_gen("We've started running the modules")
   else
     prnt_err("A burp instance is not running")
   end
  rescue => $!
    puts "#{$!}"
  end
  
end

