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
     opts(prm, pchar)
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
        retry
      end
    end
    
    
    #
    #
    #
    def opts(prm, pchar)
      self.input = Reader.new(lambda {|cmd| tabbed_comp(cmd)})
      self.iprm = underline(prm, true)
      self.pchar = clear(pchar, true)
      self.input.prm = "#{underline(prm,true)} #{clear(pchar,true) } "
    end
  
  attr_accessor :input, :prm, :iprm
  attr_accessor :pchar
    
end

end end end end