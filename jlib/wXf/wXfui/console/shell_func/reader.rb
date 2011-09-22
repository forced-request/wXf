#
# This class is used a means of providing readline instance/prompt
#
# Great tutorial at http://bogojoker.com/readline/
# Check it out if you choose to implent readline in your code and want to learn
#

module WXf
module WXfui
module Console
module Shell_Func
  
  class Reader
 
  attr_accessor :prm, :pchar
  
   #
   # Provides a readline instance, important for the console to function
   #   
   def initialize(tab_completion=nil)
     rl_check
     rl_tabcomp_engine(tab_completion)
     history = History.new
     @file = File.open(history.history_file, "a")
   end
   
   
   #
   # Method which once called, will begin a readline prompt
   #   
   def grab        
     line = nil
     begin          
      line = ::Readline.readline(prm, true)
      if not line =~ /^\s*$/
        @file.puts(line)
      end
      end
    return line
   end
      
 
     #
     # Readline require check
     #   
     def rl_check
       if (!Object.const_defined?('Readline'))
           begin
                 require 'readline'
           rescue ::LoadError
                 require 'rbreadline_compat'
           end   
       end
     end
      
  
     #
     # Tab_completion
     #
     def rl_tabcomp_engine(tab_completion)
           if (!tab_completion.nil?)
              ::Readline.basic_word_break_characters = "\x00"
              ::Readline.completion_proc = tab_completion
           end
     end
 
  end
  
end end end end