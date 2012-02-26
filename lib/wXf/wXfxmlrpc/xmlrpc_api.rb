module WXf
  module WXfXmlRpc
    
  class XmlPipe
    
    def initialize
      @pipe = Socket.pair(Socket::AF_UNIX, Socket::SOCK_STREAM, 0)
      @sockets = Socket.pair(Socket::AF_UNIX, Socket::SOCK_STREAM, 0)
      self.output = self
      self.input = self
    end
    
    def clear_pipe
      @pipe.clear
    end
   
    def pipe
      return @pipe
    end
   
    def read
      line = @pipe[1].gets
      return line

    end
    
    def push_line(line)
      @pipe[0].puts(line)
    end
    
    def print(str="")
      @pipe[0].puts(str)
    end

    def puts(str="")
       @pipe[0].puts("#{str}\n")
    end
      
    def prnt_gen(str = '')
      final_print("-{*}-", "#{str}")
    end
      
    def prnt_err(str = '')
       final_print("-{-}-", "#{str}")
    end 
      
    def prnt_plus(str = '')
       final_print("-{+}-", "#{str}")
    end
    
    def prnt_dbg(str = '')
       final_print("-{!}-", "#{str}")
    end
    
    def final_print(color_symbol, str = ''); 
        @pipe[0].puts("#{color_symbol}#{str}\n")
    end
    
    alias print_status prnt_gen
    alias print_error prnt_err
    alias print_good prnt_plus
    alias print_debug prnt_dbg
    alias p puts
    
    def red(str, pr_based=nil) 
      return str
    end  
          
    def blink(str, pr_based=nil)
      return str
    end
          
    def green(str, pr_based=nil)
      return str
    end
          
    def clear(str, pr_based=nil)
      return str
    end
          
    def dark_green(str, pr_based=nil)
      return str
    end
            
    def yellow(str, pr_based=nil)
      return str
    end
            
    def underline(str, pr_based=nil)
      return str
    end
            
    def blue(str, pr_based=nil)
      return str
    end
          
    def dark_blue(str, pr_based=nil)
      return str
    end
          
    def purple(str, pr_based=nil)
      return str
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
    
    EOF = "\xFF"
    
    def initialize
      self.pipe = XmlPipe.new
      self.console = WXf::WXfui::Console::Operations::Control.new("wXf", "//>", {'Output' => self.pipe, 'Input' => self.pipe})
      self.thread = Thread.new {self.console.start}
    end
    
    def test_connection
      return 200
    end
    
    def cmd(args)
      self.pipe.command(args.to_s)
      return EOF
    end
    
    
    def read
      pipe = self.console.output.read
      return pipe
    end
    
   
    
  end
 

end end 
