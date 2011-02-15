module WXf
module WXfui
module Console
module Prints
  
  
  module PrintSymbols
  
    include PrintColor
    
          def prnt_gen(text = '')
            print_single(blue("-{*}-") + "#{text}")
          end
          
          
          def prnt_err(text = '')
            print_single(red("-{-}-") + "#{text}")
          end
          
          def prnt_plus(text = '')
            print_single(green("-{+}-") + "#{text}")
          end
          
          def prnt_dbg(text = '')
            print_single(yellow("-{!}-") + "#{text}")
          end
          
          
          def print_single(text = '')
            print("#{text}" + "\n")
          end
    
      
          alias print_status prnt_gen 
          alias print_error prnt_err
          alias print_good prnt_plus
          alias print_debug prnt_dbg
    
  end
  
  
end end end end