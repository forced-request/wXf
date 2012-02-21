module WXf
module WXfui
module Console
module ShellIO
  
  class Output
    
    include WXf::WXfui::Console::Prints::PrintColor
    
    def initialize
      super()
    end

    
    def print(str="")
        $stdout.print(str)
        $stdout.flush()
        str
    end
      
    def puts(str="")
        print("#{str}\n")
    end
      
    def prnt_gen(str = '')
        final_print(blue("-{*}-"), "#{str}")
    end
      
    def prnt_err(str = '')
        final_print(red("-{-}-"), "#{str}")
    end 
      
    def prnt_plus(str = '')
        final_print(green("-{+}-"), "#{str}")
    end
    
    def prnt_dbg(str = '')
        final_print(yellow("-{!}-"), "#{str}")
    end
    
    alias print_status prnt_gen
    alias print_error prnt_err
    alias print_good prnt_plus
    alias print_debug prnt_dbg
    alias p puts
    
    def final_print(color_symbol, str = ''); 
        print("#{color_symbol} #{str}\n")
    end
    
  end
  
end end end end