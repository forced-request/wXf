require 'webrick/https'
require 'openssl'

module WXf
  module WXfXmlRpc
  
  class XmlRpcServer < ::WEBrick::HTTPServer

    attr_accessor :pid

    def initialize(control, port=nil)
      @control = control
      port = 9000 if port == nil      
      super(
            :Port => port,
            :AccessLog => [],
            :Logger => WEBrick::Log::new("/dev/null", 7),
            :SSLEnable => true,
          
            :SSLVerifyClient => ::OpenSSL::SSL::VERIFY_NONE,
            :SSLCertName => [ [ "CN", WEBrick::Utils::getservername ] ]
            )
    end
    
    def start_server
       self.pid = Thread.new do
        self.start
      end
    end
    
    def stop_server
      pid.kill
      @control.prnt_gen("Stopping xmlrpc server...")
      self.pid = nil
      self.shutdown
    end
    
    def mount(path, handler)
      super(path, handler)
    end
  
  end 


end end 
