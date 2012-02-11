module WXf
module WXfui
module Console
module ShellIO
  
module Medium

  module Output
    
    def print(str="")
        
    end
      
    def puts(str="")
      
    end
      
    def prnt_gen(str = '')
        
    end
      
    def prnt_err(str = '')
       
    end 
      
    def prnt_plus(str = '')
        
    end
    
    def prnt_dbg(str = '')
        
    end
    
    alias print_status prnt_gen
    alias print_error prnt_err
    alias print_good prnt_plus
    alias print_debug prnt_dbg
    
    def final_print(color_symbol, str = ''); 
       
    end
    
  end

  include Output
  
   def io_feed(in=nil, out=nil)
   end
  
end
  
end end end end