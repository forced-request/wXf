#
# Provides a means of maintaining hierarchy when exploits and payloads are stacked 
#


module WXf
  module WXfui
   module Console
     module Operations
     
     module ModOperator
                    
       include Operator::ArgModOperator
       
       attr_accessor :control
             
       
       def initialize(control)
         super         
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
       def active_module
         return control.active_module
       end
       
       
       #
       # Great way to maintain hierarchy
       #
       def active_module=(m)
         control.active_module = m
       end    
     
     end
     
     
     #
     # Intelligent way of keeping track of active modules and maintain in the Operator hierarchy...
     # had to borrow this idea :-) This works specifically for init'd Module classes such as Exploit, Payload
     #
     module ModuleCommandOperator
       
       include ModOperator
       
       def single_module
         return control.active_module         
       end
       
       def single_module=(m)         
         self.control.active_module = m       
       end     
              
     end
     
  end end end end