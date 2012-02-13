# Provides a means of maintaining hierarchy when exploits and payloads are stacked 
module WXf
  module WXfui
   module Console
     module Operations
     
     module ModOperator
       
       attr_accessor :control
         
       def initialize(control)
         self.control = control
       end
       
       
       #
       # Tab completion effort begins
       #
       def tab_comp_assist(str) 
         aggr = []          
         stra = str.split(/\s/) 
           if (self.respond_to?("arg_#{stra[0]}_comp"))          
            keywds = exec(str, stra)
           
            case keywds
            when nil      
            else
            aggr.concat(keywds)  
            end 
        
          end
          
           aggr         
       end  

       
       #
       #
       #
       def exec(str, stra)
        self.send("arg_#{stra[0]}_comp", str, stra)
       end
        
             
       def print(str="")
        control.print(str)
       end
      
       def puts(str="")
        control.puts(str)
       end
          
      
       def prnt_gen(str = '')
        control.prnt_gen(str)
       end
      
       def prnt_err(str = '')
        control.prnt_err(str)
       end 
      
       def prnt_plus(str = '')
        control.prnt_plus(str)
       end
    
       def prnt_dbg(str = '')
        control.prnt_dbg(str)
       end
    
       alias print_status prnt_gen
       alias print_error prnt_err
       alias print_good prnt_plus
       alias print_debug prnt_dbg
    
       def final_print(color_symbol, str = ''); 
        control.final_print("#{color_symbol} #{str}\n")
       end
          
       
       #
       # Hierarchy
       #
       def in_focus; control.in_focus; end
       def in_focus=(mod_on_stack); control.in_focus = mod_on_stack; end    
     
     end
     
     
     #
     # Intelligent way of keeping track of active modules and maintain in the Operator hierarchy...
     # had to borrow this idea :-) This works specifically for init'd Module classes such as Exploit, Payload
     #
     module ModuleCommandOperator
       
       include ModOperator
       
       def activity
         return control.in_focus      
       end
       
       def activity=(mod_on_stack)         
         self.control.in_focus = mod_on_stack       
       end     
              
     end
     
  end end end end