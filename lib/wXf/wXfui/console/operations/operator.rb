require 'wXf/wXfui/console/shell_func'

module WXf
module WXfui
module Console
module Operations 
  
  module Operator
    
     #
     # Begins Operator module content
     #
     include WXf::WXfui::Console::Shell_Func::Shell
     PRINT_SYMBOLS = WXf::WXfui::Console::Prints::PrintSymbols
     include WXf::WXfui::Console::Prints::PrintOptions
     
     attr_accessor :activities, :webstack, :tab_words, :xmlrpc_servers
     
     def initialize(prm, pchar)
       super
        init_arrys
     end
  
     
    #
    # This is how we go about dispatching the tabbed word completion stuff.
    #   
    def tabbed_comp(str)
      args = str.split
      self.tab_words = args
      
      begin
      #We won't do anything yet if the user hasn't entered anything.
      if not args.empty?
        args.pop
        
        #Check if there are any items left 
        if args.nitems >= 1
          
        #There are items left, let's handoff for processing
        tabbed_comp_handoff(str)
           
        else
          #Okay, they've only entered a bit of text, no whitespace, lets send to a grep function
          tabbed_comp_simple(str)
        end
      end
      end
    end
   
    
    #
    # This method is just for simple default operator commands. 
    # ...auto-complete for the first word only.
    #
    def tabbed_comp_simple(str)
      aggr_keys = []
        begin
        activities.each {|operator|
          if operator.respond_to?('avail_args')
          aggr_keys.concat(operator.avail_args.to_a.map { |x| x[0] })
          end
      }
      end 
      
      aggr_keys.concat(WXf::LINUX_COMMANDS)
      aggr = aggr_keys.sort
      sorted_val = aggr.grep( /^#{Regexp.escape(str)}/)   
      return sorted_val
    end
    
    
    #
    # This method is to make decisions on the more complicated auto-completion.
    # ...essentially we will need to make decisions 
    def tabbed_comp_handoff(str)
      tab_words =[]
      aggr_keys = []
      
      #Take string, create array.  
      cmds = str.split
     
      #Pop the first word entered out of that array for pattern matching
      cmd = cmds.pop
      begin
      activities.each {|operator|
        if operator.respond_to?('tab_comp_assist') 
          keywds =  operator.tab_comp_assist(str)
          if keywds.nil?
            return ['']
          else  
          aggr_keys.concat(keywds)
          end
        end      
      }  
      end
      
      aggr = aggr_keys.sort
      aggr.find_all {|e| 
        e =~ /^#{Regexp.escape("#{cmd}")}/
      }.map {|e|
        "#{cmds.join(' ')} #{tab_words.dup.push(e).join(' ')}"   
      }
    end
    
    #
    # Initiates the attr_accessors as empty arrays
    #
    def init_arrys
      self.activities = []
      self.webstack = []
      self.tab_words = []
      self.xmlrpc_servers = []
    end
    
 #    
 # Re-worked activity stack style, taken from the concept behind Android's activity stack
 # NEW PUSH AND POP SECTION. Found it better for both activities and our webserver to be pushed and popped off the stack.
 #         
      
    #
    # Activity Stack, adding to it
    #    
    def add_activity(activity)
      actv = activity.new(self) 
      self.activities.push(actv)
    end
    
    
    #
    # Removes a module from the stack
    #   
    def remove_activity
      if (self.activities) then
      self.activities.pop
      end
    end
        
    
    #
    # Removes a specific module
    #
    def destroy_activity(activity)
      self.activities.delete(activity) 
    end
  
     
    #
    # Shows the current activity in focus
    #
    def infocus_activity
      self.activities.last
    end
    
# This next portion covers the Web Server Stack.
    
    #
    # Brings a webserver instance onto the stack
    #
    def add_web_activity(web)
      if (web)
       web_inst = web
      end 
      self.webstack.push(web_inst)
    end
    
    
    #
    # Removes a Web Server instance from the stack
    #
    def remove_web_activity(id)
      webstack.delete_at(id)  
    end
    
    
    #
    # Removes a web instance, user-based function   
    # ..allows user to decide which instance to remove
    #
     def destroy_web_activity(name)
       if (name)
       self.webstack.delete(name)
       end
     end
     
     
     #
     # Returns the in-focus activity on the stack
     #
     def infocus_web_activity
       self.webstack.last
     end

# This portion of operator.rb is deals with processing user commands.
# Either the instances on the operator stack have the command or we 
# ...send to the system.  
    
    #
    # Method concantenates user input (first word) with arg_ prefix and 
    # ...searches instances on the stack to see if they have a arg_"userInput" 
    # ...method 
    #               
    def runcmd(line)
      if line.kind_of?(String)
        args = line.split
      else
        args = line
      end
      
      command = args.shift
      found = false
      entries = activities.length
            
      if not command.nil?
        concat_cmd = "arg_" + command
      end
      
      if (command)
        activities.each {|operator|
              begin
                if operator.avail_args.has_key?(command)
             
                  run_command(operator, command, args)
                  found = true
                end
              end
              break if (activities.length != entries)
        }
       if found == false
          misc_cmd(command, line)
       end
      end
      return found
    end

    
    #
    # If a command isn't found to exist in either the operator stack
    # ...or the host system a message is sent to the user.
    #
    def misc_cmd(command,line)
      prnt_dbg(" Command does not exist: #{command}.")
    end
 
    
    #
    # If an operator is found to have the arg_"userInput" 
    # ...method, we call the method on the appropriate operator stack instance
    # 
    def run_command(operator, command, args) 
     operator.send('arg_' + command, *args)
    end  
    
  end
 

end end end end