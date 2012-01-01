module WXf
  module WXfXmlRpc

  class XmlRpcApi
    
    def initialize(control)
      @control = control
    end
    
    def test_connection
      return 200
    end
    
    def arg_use(mod)
      @control.activities[0].arg_use("#{mod}")
    end

    def arg_set(options)
      output = ""
      if options.kind_of?(String)
        opts = options.split(',')
        @control.activities[0].arg_set(*opts)
      end
      return output
    end
    
    def arg_show
      return @control.infocus_activity.to_s
    end
    
    def arg_run
      cmd = @control.runcmd("run")
      t = @control.read
      return t.to_s
    end
        
  end

end end 
