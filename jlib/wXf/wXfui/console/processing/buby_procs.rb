#
# Contains the name of the class being stacked and available commands
#

module WXf
module WXfui
module Console
module Processing
  
  class BubyProcs
    
    include WXf::WXfui::Console::Operations::ModuleCommandOperator
    
    def name
      "Buby" 
    end
    
    def avail_args
      {
      "run" => "Starts burp"
       }
    end

    #
    # Runs this bad boy
    #
    def arg_run(*cmd)
      activity.run
    end
    
    
       
    
   
  end
  
end end end end