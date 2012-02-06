module WXf
  module WXfXmlRpc
 
  class XmlRpcApi
  
    def initialize
      @console = WXf::WXfui::Console::Operations::Control.new("wXf", "//>", {'PRINT_SYM' => XmlRpcShell})
    end
    
    def test_connection
      return 200
    end
    
    def cmd(args)
      @console.runcmd("#{args}")
      return @console.read
    end
    
    def arg_use(mod)
      @console.activities[0].arg_use("#{mod}")
      return @console.read
    end

    def arg_set(options)
      if options.kind_of?(String)
        opts = options.split(',')
        @console.activities[0].arg_set(*opts)
      end
      return @console.read
    end
    
    def arg_show
      return @console.infocus_activity.to_s
    end
    
    def arg_run
      @console.runcmd("run")
      return @console.read
    end
        
  end
 

end end 
