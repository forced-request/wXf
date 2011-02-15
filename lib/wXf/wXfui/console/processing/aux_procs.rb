#
# Contains the name of the class being stacked and available commands
#

module WXf
module WXfui
module Console
module Processing
  
  class AuxiliaryProcs 
    
    include WXf::WXfui::Console::Operations::ModuleCommandOperator


    
    def name
      "Auxiliary" 
    end
  
    
    #
    # Available arguments
    #
    def avail_args; {"run" => "Runs the module"}; end
    
    
    #
    # Checks and error handling, nm at the moment tho :-)
    #
    def arg_run(*cmd)     
      begin
        single_module.run
     rescue => $!
        print("The following error occurred: #{$!}" + "\n")
     end   
   
    end  
     
  end
  
end end end end    