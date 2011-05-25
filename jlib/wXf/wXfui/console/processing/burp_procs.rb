#
# Contains the name of the class being stacked and available commands
#

module WXf
module WXfui
module Console
module Processing
 
  
  class BurpProcs
    attr_accessor :burpa    
    include WXf::WXfui::Console::Operations::ModuleCommandOperator
    
    def name
      "Burp" 
    end
    
    def avail_args
      {
        "alert"  =>  "Sends an alert",
        "restore" => "Restores from a state file, Ex: restore /tmp/save_state",
        "start"   => "Starts Burp",
        "stop"    => "Stops Burp"         
       }
    end

    #
    # Runs this bad boy
    #
    def arg_start(*cmd)
      burp = control.in_focus.options['BURP']
      if not burp == "" and File.exist?(burp) 
        if ($burp)
          control.prnt_dbg("An instance of Burp is already running!")
        else       
          Buby.load_burp(burp)
          $burp = Buby.new()        
          $burp.start_burp()
        end
      else
        control.prnt_err("Either a location for Burp wasn't specified or the location was incorrect")    
      end
    end
    
    #
    # Stops the burp instance
    # 
    def arg_stop(*cmd)
      if $burp
        $burp.close
      end
    end
    
    #
    # Sends an alert to Burp
    #
    def arg_alert(*cmd)
      if $burp
        $burp.alert("#{cmd.join(" ")}") 
      end 
    end
    
    
    #
    # Allows the user to restore their state
    #
    def arg_restore(*cmd)
      if $burp
        if $burp.respond_to?("restore_state")
          if File.exists?("#{cmd}")         
            $burp.restore_state("#{cmd}")
          else
            control.prnt_err("This restore file does not exist!")
          end
        else
          control.prnt_err("It would appear your version of Burp doesn't allow a restore :-(")
        end
      else
        control.prnt_err("No instance of Burp is running!")
      end
    end
       
    
   
  end
  
end end end end