module WXf
  module WXfXmlRpc
    
  class XmlPipe
    
    def initialize
      @pipe = []
      @sockets = Socket.pair(Socket::AF_UNIX, Socket::SOCK_STREAM, 0)
      self.output = self
      self.input = self
    end
    
    def clear
      @pipe.clear
    end
    
    def pipe
      return @pipe
    end
    
    def read
      npipe = []
      npipe.concat(@pipe)
      npipe.push(prm)
      @pipe.clear
      return npipe
    end
    
    def push_line(line)
      @pipe.push(line)
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
    
    attr_accessor :prm, :pchar, :output, :input
    
    def command(val)
       @sockets[0].puts(val)
    end
    
    def grab
      line = @sockets[1].gets
      print("#{prm}#{line}\n")
      return line
    end
  
  end
  
  class XmlRpcApi
   
    attr_accessor :console, :pipe, :thread
   
    def initialize
      mutex = Mutex.new
      self.pipe = XmlPipe.new
      self.console = WXf::WXfui::Console::Operations::Control.new("wXf", "//>", {'Output' => self.pipe, 'Input' => self.pipe})
      self.thread = Thread.new {self.console.start}
      self.pipe.clear
    end
    
    def test_connection
      return 200
    end
    
    def cmd(args)
      self.pipe.command(args.to_s)
      return []
    end
    
    def read_output
      return self.console.output.read.to_s
    end
    
  end
 

end end 
