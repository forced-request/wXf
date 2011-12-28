module WXf
module WXfui
module Console
module Operations

  
  class Control
    
    attr_accessor :in_focus
    
    include Operator
    
      def initialize(*all)
        require 'rbreadline_compat'
        super
        stack_n_play
      end
   
      #
      #
      #
      def stack_n_play
        add_activity(WXf::WXfui::Console::Processing::CoreProcs)
        display_now
      end
      
        
      #Do NOT remove this!!!
      def framework  
         WXf::WXfmod_Factory::Framework.new
      end
  
                
      #
      # Misc command, basically something that didn't show up in the 
      # ...available arguments of an activity on the stack
      #  
      def misc_cmd(command, line)
          if (WXf::WXfui::Console::Shell_Func::FileUtility.command_bin(command))
          prnt_gen(" exec command: #{line}"+ "\n")
          begin
           system_call(line)
           rescue $!
           prnt_err(" Console call error: #{$!}")
          end
          return
        end
        super
      end
      
      
       #      
       # Method which invokes a pretty startup icon from 
       # coreprocs by called arg_banner
       #      
       def display_now
         if infocus_activity.respond_to?('display')
            infocus_activity.send("arg_display")
         end
       end
      
       
       #
       # System call
       #
       def system_call(line)
         return unless WXf::WXfui::Console::Shell_Func::FileUtility.platform_detection != "WIN"
         exec = ::IO.popen(line, "r")
         exec.each {|data|
          print(data)           
         }
         exec.close
       end      
  
  end
 
end end end end