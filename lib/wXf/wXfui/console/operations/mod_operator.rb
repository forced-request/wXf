#
# Provides a means of maintaining hierarchy when exploits and payloads are stacked 
#


module WXf
  module WXfui
   module Console
     module Operations
     
     module ModOperator
                    
       #include Operator::ArgModOperator
       
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
         if (avail_args.include?(stra[0]))        
            if (self.respond_to?("arg_#{stra[0]}_tabs"))          
            keywds = self.send('arg_'+stra[0]+'_tabs', str, stra)
            return nil if keywds.nil?
            aggr.concat(keywds)           
            else           
                return nil        
            end 
        end            
            return aggr         
       end  

       
       #
       # Great way to maintain hierarchy
       #
       def in_focus
         return control.in_focus
       end
       
       #
       # Great way to maintain hierarchy
       #
       def in_focus=(mod_on_stack)
         control.in_focus = mod_on_stack
       end    
     
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