#
# Shell class called by Control (for now) which can both begin a prompt loop
# ...and update the prompt
#


module WXf
module WXfui
module Console
module Shell_Func

  
module Shell


  attr_accessor :input, :prompt, :init_prompt
  attr_accessor :prompt_char
  
 
    def initialize(prompt, prompt_char)
      self.input = Reader.new(lambda {|cmd| tabbed_comp(cmd)})
      self.init_prompt = underline(prompt, true)
      self.prompt_char = clear(prompt_char, true)
      self.input.prompt = "#{underline(prompt,true)} #{clear(prompt_char,true) } "
    end
  
    
    #
    # Self Descriptive, updates the prompt with whatever we input.
    #
    def update_prompt(prompt=nil)
      dup_prompt = "#{self.input.prompt.dup}"  
      if (prompt)
          new_prompt = "#{self.prompt} #{prompt}#{prompt_char} "
         test =  dup_prompt.gsub!("#{self.input.prompt}", "#{new_prompt}")
        self.input.prompt = "#{test}"
      end
    end
  
  
    #
    # Initiates the console
    #
    def start
      self.prompt = init_prompt
      begin
       while true
         line = input.fetch
         run_single(line)
      end
      rescue Interrupt
        print("Interrupt: use the 'exit' command to quit" + "\n" )
        retry
      end
    end
  
end

end end end end