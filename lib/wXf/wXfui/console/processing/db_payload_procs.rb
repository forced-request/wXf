#
# Contains the name of the class being stacked and available commands
#

module WXf
module WXfui
module Console
module Processing

  
  class DbPayloadProcs
    
    include WXf::WXfui::Console::Operations::ModuleCommandOperator

    
    
   #
   # Does absolutely nothing but is required for the operator to send commands 
   # ..to the appropriate class on the stack and would cause a crash if removed.   
   # 
    def avail_args; {}; end
   
   
   
   
   #
   # Returns the name of the class when asked
   #
   def name     
     "Payload"     
   end
   

   
  end
  
  class Create_Payload
    include WXf::WXfui::Console::Operations::ModuleCommandOperator
        def name         
          "Create_Payload"           
        end
      
        
       
        def avail_args; {"commit" => "Commit the payload to the database. !!ENSURE TO SHOW/SET OPTIONS!!"}; end 
        
        
        #
        # Commit changes to the database
        #
        def arg_commit(*cmd)
          puts "[wXf] Commit payload #{active_module.options['NAME']} to database"
          begin
            WXFCORE.db.create_payload(active_module.options)
          rescue
            puts "[wXf] Error adding payload to database: #{$!}"
          end
        end
        
        
        #
        # Provides the help we need
        #
        def arg_help
          active_module.help
        end

  end
  
end end end end   