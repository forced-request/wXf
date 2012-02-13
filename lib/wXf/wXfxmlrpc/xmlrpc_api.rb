module WXf
  module WXfXmlRpc
 
  class XmlOutput
    
    def initialize
      @pipe = []
    end
    
    def read
      npipe = []
      npipe.concat(@pipe)
      @pipe.clear
      return npipe
    end
    
    def print(str="")
       @pipe.push(str)
    end
      
    def puts(str="")
       @pipe.push(str)
    end
      
    def prnt_gen(str = '')
      @pipe.push("-{*}- #{str}")
    end
      
    def prnt_err(str = '')
       @pipe.push("-{-}- #{str}")
    end 
      
    def prnt_plus(str = '')
       @pipe.push("-{+}- #{str}")
    end
    
    def prnt_dbg(str = '')
       @pipe.push("-{!}- #{str}")
    end
    
    alias print_status prnt_gen
    alias print_error prnt_err
    alias print_good prnt_plus
    alias print_debug prnt_dbg
    alias p puts
    
    def final_print(color_symbol, str = ''); 
        @pipe.push("#{str}")
    end
    
    
  end
  
  
  class XmlRpcApi
  
    def initialize
      @output = XmlOutput.new
      @console = WXf::WXfui::Console::Operations::Control.new("wXf", "//>", {'Output' => @output})
    end
    
    def test_connection
      return 200
    end
    
    def cmd(args)
      @console.runcmd("#{args}")
      return @output.read
    end
    
    def arg_use(mod)
      @console.activities[0].arg_use("#{mod}")
      return @output.read
    end

    def arg_set(options)
      if options.kind_of?(String)
        opts = options.split(',')
        @console.activities[0].arg_set(*opts)
      end
      return @output.read
    end
    
    def arg_show
      return @console.infocus_activity.to_s
    end
    
    def arg_run
      @console.runcmd("run")
      return @output.read
    end
        
  end
 

end end 
