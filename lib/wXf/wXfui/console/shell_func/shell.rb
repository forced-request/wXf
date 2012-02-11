#
# Shell class called by Control (for now) which can both begin a prompt loop
# ...and update the prompt
#


module WXf
module WXfui
module Console
module Shell_Func

  
module Shell

    include WXf::WXfui::Console::Prints::PrintOptions
    include WXf::WXfui::Console::Prints::PrintColor
  
    def initialize(prm, pchar)
      self.iprm = underline(prm, true)
      self.pchar = clear(pchar, true)
      self.input = Reader.new(lambda {|cmd| tabbed_comp(cmd)})
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
        output.print
    end
      
    def puts(str="")
        output.print(str)
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
    alias p print
    
    def final_print(color_symbol, str = ''); 
        print("#{color_symbol} #{str}\n")
    end
    
    def io_feed(input=nil, output=nil)
        #self.input = input if input
        self.output = output
        self.extend(WXf::WXfui::Console::ShellIO::Output) if output.nil?
    end

  attr_accessor :input, :output, :prm, :iprm
  attr_accessor :pchar
    
end

end end end end