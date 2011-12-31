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
      return unless self.pid != nil
      Process.kill("KILL", self.pid)
      @control.prnt_gen("Stopping xmlrpc server with process id: #{self.pid}")
      self.pid = nil
      self.shutdown
    end
    
    def mount(path, handler)
      super(path, handler)
    end
  
  end 


end end 
