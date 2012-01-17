module WXf
  module WXfXmlRpc

 module ExtendedShell
    attr_accessor :io_pipe
    
    def init_io
      self.io_pipe = []
    end
    
    def read
      test = []
      test.concat(io_pipe)
      io_pipe.clear
      return test
    end
    
  end 


  
 module XmlRpcShell
  
    include ExtendedShell
    
    def puts(str = '')
       io_pipe.push(str)
    end
    
    def print(str='')
      io_pipe.push(str)
    end
    
    def prnt_gen(str = '')
       io_pipe.push(str)
    end
    
    def prnt_err(str = '')
       io_pipe.push(str)
    end
          
    def prnt_plus(str = '')
       io_pipe.push(str)
    end
          
    def prnt_dbg(str = '')
       io_pipe.push(str)
    end
    
    def print_status(str = '')
      io_pipe.push(str)
    end
    
    def print_error(str = '')
      io_pipe.push(str)
    end
    
    def print_good(str = '')
      io_pipe.push(str)
    end
    
    def print_debug(str = '')
      io_pipe.push(str)
    end
      
    def final_print(color_symbol, strn = ''); 
      print("#{color_symbol} #{strn}\n")
    end
    
 end
 

 

  class XmlRpcApi
    
    attr_accessor :console
  
    
    def initialize(control)
      self.console = WXf::WXfui::Console::Operations::Control.new("wXf", "//>")
      self.console.extend(XmlRpcShell)
      self.console.init_io
      super()
    end
    
    def test_connection
      return 200
    end
    
    def ls
      console.runcmd("ls")
      return self.console.read
    end
    
    def arg_use(mod)
      console.activities[0].arg_use("#{mod}")
      return self.console.read
    end

    def arg_set(options)
      if options.kind_of?(String)
        opts = options.split(',')
        console.activities[0].arg_set(*opts)
      end
      return self.console.read
    end
    
    def arg_show
      return console.infocus_activity.to_s
    end
    
    def arg_run
      console.runcmd("run")
      return self.console.read
    end
        
  end
 

end end 
