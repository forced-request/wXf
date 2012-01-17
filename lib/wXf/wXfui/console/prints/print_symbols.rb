module WXf
module WXfui
module Console
module Prints
  
  
  module PrintSymbols
  
    include PrintColor
          
          def print(str="")
            $stdout.print("#{str}")
            #$stdout.flush
          end
          
          def prnt_gen(strn = ''); final_print(blue("-{*}-"), "#{strn}"); end
          def prnt_err(strn = ''); final_print(red("-{-}-"), "#{strn}"); end
          def prnt_plus(strn = '');final_print(green("-{+}-"), "#{strn}"); end
          def prnt_dbg(strn = ''); final_print(yellow("-{!}-"), "#{strn}"); end
          alias print_status prnt_gen
          alias print_error prnt_err
          alias print_good prnt_plus
          alias print_debug prnt_dbg
          def final_print(color_symbol, strn = ''); 
           print("#{color_symbol} #{strn}\n")
          end
    
  end
  
  
end end end end