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
        "start"   => "Starts Burp",
        "stop"    => "Stops Burp",         
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
    #
    #
    def arg_alert(*cmd)
      if $burp
        $burp.alert("#{cmd.join(" ")}") 
      end 
    end
    
       
    
   
  end
  
end end end end