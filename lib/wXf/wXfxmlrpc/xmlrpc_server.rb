module WXf
  module WXfXmlRpc
  
  class XmlRpcServer < ::WEBrick::HTTPServer

    attr_accessor :pid

    def initialize(control, port=nil)
      @control = control
      port = 9000 if port == nil
      super(:Port => port)
    end
    
    def start_server
       self.pid = fork do
        self.start
      end
    end
    
    def stop_server
      Process.kill("KILL", self.pid)
      self.pid = nil
      self.shutdown
      @control.prnt_gen("Stopping xmlrpc server with process id: #{self.pid}")
    end
    
    def mount(path, handler)
      super(path, handler)
    end
  
  end 


end end 
