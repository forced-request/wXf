#
# Shell class called by Control (for now) which can both begin a prompt loop
# ...and update the prompt
#


module WXf
module WXfui
module Console
module Shell_Func

  
module Shell
  
    def initialize(prm, pchar)
      self.iprm = underline(prm, true)
      self.pchar = clear(pchar, true)
      self.input.prm = "#{underline(prm,true)} #{clear(pchar,true) } "
    end
    
    #
    # modifies console prompt with whatever we input.
    #
    def mod_prm(prm=nil)
          dup_prm = "#{self.input.prm.dup}"  
      if (prm)
          new_prm = "#{self.prm} #{prm}#{pchar} "
          test =  dup_prm.gsub!("#{self.input.prm}", "#{new_prm}")
          self.input.prm = "#{test}"
      end
      input.input_line = "#{test}" if input.respond_to?('input_line')
    end
  
  
    #
    # Initiates the console
    #
    def start
      self.prm = iprm
      begin
       while true
         line = input.grab
         runcmd(line)
      end
      rescue Interrupt
       print("\nExample: use the 'exit' command to quit\n\n" )
        WXf::WXfassists::General::MechReq.count(0) 
        retry
      end
    end  
    
    
    def print(str="")
        output.print(str)
    end
      
    def puts(str="")
        output.puts(str)
    end
      
    def prnt_gen(str = '')
        output.prnt_gen(str)
    end
      
    def prnt_err(str = '')
        output.prnt_err(str)
    end 
      
    def prnt_plus(str = '')
        output.prnt_plus(str)
    end
    
    def prnt_dbg(str = '')
        output.prnt_dbg(str)
    end
    
    alias print_status prnt_gen
    alias print_error prnt_err
    alias print_good prnt_plus
    alias print_debug prnt_dbg
    alias p puts
    
    def final_print(color_symbol, str = ''); 
        print("#{color_symbol} #{str}\n")
    end
    
    def red(str, pr_based=nil) 
            output.red(str, pr_based)        
          end  
         
          
          def blink(str, pr_based=nil)
            output.blink(str, pr_based)
          end
          
          def green(str, pr_based=nil)
            output.green(str, pr_based)
          end
          
          def clear(str, pr_based=nil)
            output.clear(str, pr_based)
          end
          
          def dark_green(str, pr_based=nil)
            output.dark_green(str, pr_based)
          end
            
          def yellow(str, pr_based=nil)
            output.yellow(str, pr_based)
          end
            
          def underline(str, pr_based=nil)
             output.underline(str, pr_based)
          end
            
          def blue(str, pr_based=nil)
            output.blue(str, pr_based) 
          end
          
          def dark_blue(str, pr_based=nil)
            output.dark_blue(str, pr_based)
          end
          
          def purple(str, pr_based=nil)
            output.purple(str, pr_based) 
          end
    
    module OutputShim
        attr_accessor :output, :prm, :pchar, :iprm, :print_opts
        
    end

    
    def io_feed(input=nil, output=nil)
       self.input = input || Reader.new(lambda {|cmd| tabbed_comp(cmd)})
       self.input.extend(OutputShim)
       self.input.output = output.nil? ? WXf::WXfui::Console::ShellIO::Output.new : output
       self.output = self.input.output
       self.print_opts = WXf::WXfui::Console::Prints::PrintOptions.new(self.output, framework)
     end

  attr_accessor :input, :output, :prm, :iprm
  attr_accessor :pchar, :print_opts
    
end

end end end end