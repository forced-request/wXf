module WXf
  module WXfXmlRpc

 module XmlRpcShell
    
    attr_accessor :pipe
    
    def initialize
     self.pipe = ''
    end
    
    def read
       self.pipe = self.control.start
    end
  end

  class XmlRpcApi
    
    include WXf::WXfXmlRpc::XmlRpcShell
    attr_accessor :control
  
    
    def initialize(control)
      self.control = WXf::WXfui::Console::Operations::Control.new("wXf", "//>" )
      super()
    end
    
    def test_connection
      return 200
    end
    
    def ls
      control.runcmd("ls")
      return self.read.to_s
    end
    
    def arg_use(mod)
      control.activities[0].arg_use("#{mod}")
    end

    def arg_set(options)
      output = ""
      if options.kind_of?(String)
        opts = options.split(',')
        control.activities[0].arg_set(*opts)
      end
      return output
    end
    
    def arg_show
      return control.infocus_activity.to_s
    end
    
    def arg_run
      cmd = control.runcmd("run")
    end
        
  end
 

end end 
