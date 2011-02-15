#
# Base class for which object's state are held. Drives the ship.
#

module WXf
module WXfui
module Console
module Operations

  
  class Control
    
    attr_accessor :active_module
    
    include Operator
    
      def initialize(prompt, prompt_char)
        require 'rbreadline_compat'
        super
        enstack_operator(WXf::WXfui::Console::Processing::CoreProcs)
        #As of now, just shows the banner to the users
        on_startup
        end
   
        
      #Do NOT remove this!!!
      def framework  
         WXf::WXfmod_Factory::Framework.new
      end
        
      def misc_cmd(command, line)
        if (WXf::WXfui::Console::Shell_Func::FileUtility.command_bin(command))
          prnt_gen(" run: #{line}"+ "\n")
           begin
           io = ::IO.popen(line, "r")
           io.each_line do |data|
            print(data)           
           end
           io.close
           rescue ::Errno::EACCES, ::Errno::ENOENT
           prnt_err(" Permission denied exec: #{line}")
                            
          end
          return
        end
        super
      end
        
      
       #      
       # Method which invokes a banner from coreprocs by called arg_banner
       #      
       def on_startup
         run_single("display")
       end
            
  
  end
 
end end end end