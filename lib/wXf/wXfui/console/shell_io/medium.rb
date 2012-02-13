module WXf
module WXfui
module Console
module ShellIO
  
module Medium

  module Output
    
    attr_accessor :output_medium
    
    def print(str="")
      output_medium.print(str) if output_medium
    end
      
    def puts(str="")
       output_medium.puts(str) if output_medium
    end
      
    def prnt_gen(str = '')
        output_medium.prnt_gen(str) if output_medium
    end
      
    def prnt_err(str = '')
        output_medium.prnt_err(str) if output_medium
    end 
      
    def prnt_plus(str = '')
        output_medium.prnt_plus(str) if output_medium
    end
    
    def prnt_dbg(str = '')
        output_medium.prnt_dbg(str) if output_medium
    end
    
    alias print_status prnt_gen
    alias print_error prnt_err
    alias print_good prnt_plus
    alias print_debug prnt_dbg
    alias p puts
    
    def final_print(color_symbol, str = ''); 
       output_medium.final_print(str) if output_medium
    end
    
  end
  
  module Input
    attr_accessor :input_medium
  end
  
  
  include Input
  include Output
  
   def io_feed(input=nil, output=nil)
     self.input_medium = input
     self.output_medium = output
   end
  
  
  
end
  
end end end end