#Important to call wAx here
require 'wAx'

module WXf
module WXfui
module Console
module Processing


class CoreProcs
  
  attr_accessor :control, :framework, :exploit_opts, :svr, :mpholder
  
  include WXf::WXfui::Console::Operations::ModOperator
 
      def initialize(control)
        super
            self.control = control
            self.framework =  control.framework
      end

 
      #
      # Update command
      #  
      def arg_update(*cmd)
        force_up = false
        if !cmd.empty?
          if cmd.first == "force"
            force_up = true
          else
            control.prnt_err('Please type "update" or "update force" only') 
           return
          end
        end      
        pwd = Dir.pwd      
        if pwd == WXf::WorkingDir
          if (force_up)
            exec_f = ::IO.popen("git checkout -f", "r")
            exec_f.each do |data|
              print(data)
            end
            exec_f.close
          end
          exec = ::IO.popen("git pull", "r")
          exec.each do |data|
            print(data)
          end
          exec.close
        else
          control.prnt_err("You need to be in wXf root directory to update")
        end
      end                    
      
      
    #   
    # When the user types "use" 
    #
    def arg_use(*cmd)
      # This is a module name placeholder so we can reload easily
      self.mpholder = ''
      
      if (cmd.length == 0)
        control.prnt_dbg(" Example: use <module name>\n\n")
           return false
      end 
      arg_name = cmd[0]      
      begin
       
        activity = fw_mod?(arg_name, control)
        
        if activity.nil?
         return false
        end
        
        operator = nil
        
        if activity.respond_to?("type")
          actv_type = activity.type
        end
        
       case (actv_type)
       when EXP
         operator = ExpProcs   
       when AUXILIARY
         operator = AuxiliaryProcs
        else
         control.prnt_err(" Please ensure you are not trying to use a Payload")
         return false
        end
      
      end
        
      in_focus?
       
      if (operator != nil)
        control.add_activity(operator)
      end
      
     self.in_focus = activity  
     
     if auxiliary? or exploit?
       #short term workaround
       nickname = arg_name.split('/')
       control.mod_prm("#{activity.type}" + control.red("(#{nickname.last})", true))
     else
       self.mpholder = arg_name
       control.mod_prm("#{activity.type}" + control.red("(#{arg_name.split('/').last})", true))
     end
             
    end
    
    def in_focus?
    if self.in_focus
      arg_back()
    end
    end
    

    #
    #
    #
    def fw_mod?(name, control)
      @mod = framework.modules.load(name, control)
      if @mod.nil?
        control.prnt_err(" This is not the module you are looking for: (#{name})") and return nil
      else
        return @mod
      end
    end
   
    
    #
    #These will get shifted around eventually, for now they lighten the load on if/elsif/else type programming
    #
    def auxiliary?
     in_focus.type == 'auxiliary'
    end
        
    def exploit?
      in_focus.type == 'exploit'
    end
    
    
    #
    # Use tab helper
    #
    def arg_use_comp(str, stra)
     mods = framework.modules.module_list
     return mods
    end
    
    #
    # Suppots the decision making process of which options to set with arg_set.
    #
    def option_name(cmd)
        name_of_opt = cmd
        opt = nil
        opt_type = nil
        
        if (in_focus.type == WEBSERVER) and (in_focus.options.has_key?(name_of_opt))
          opt = 'webserver_options'
        elsif (in_focus.respond_to?('payload')) and 
          (in_focus.payload.respond_to?('options')) and 
          (in_focus.payload.options.has_key?(name_of_opt))
          opt_type = in_focus.payload.options[name_of_opt].data_type
          opt = 'payload'   
        elsif (in_focus.type == AUXILIARY) and (in_focus.options.has_key?(name_of_opt))
          opt_type = in_focus.options[name_of_opt].data_type
          opt = 'auxiliary' 
        elsif (in_focus.type == EXP) and (in_focus.options.has_key?(name_of_opt))  
          opt_type = in_focus.options[name_of_opt].data_type
          opt = 'exploit'
        elsif (name_of_opt == "PAYLOAD")  
          opt = 'PAYLOAD'
        else
          control.prnt_err(" Please enter a valid option, use show options") 
          return false
        end
        
       return opt, opt_type 
      end
    
      
    #
    # Used to set options and payloads
    #
    def arg_set(*cmd)
      if cmd[1].nil?
              control.prnt_err(" Please enter an option and value")      
       return false 
      end
      
      arg_opt = cmd[0]
   
      if (in_focus) and not (cmd[1].nil?)
        opt, opt_type = option_name(cmd[0]) 
        # If this is a payload, lets get it processed as such
        case opt 
        when 'PAYLOAD'
          option_payload(cmd[1].to_s)
        when 'webserver_options'
          in_focus.options[arg_opt] =  process_set_cmd(cmd)
        else
          # Need to get the command processed and in a nice format
          processed_command = process_set_cmd(cmd)    
          # For anything that isn't a payload or webserver option, decide where to send it
          # ...for further processing
          case opt_type
          when 'Integer'
            set_engine(option_integer(processed_command), opt, arg_opt)
          when 'Boolean'
            set_engine(option_boolean(processed_command), opt, arg_opt)
          when 'String'
            set_engine(option_string(processed_command), opt, arg_opt)
          end 
        end
      end  
    end  
    
    
    #
    #  "set" decision engine based off opt  
    #
    def set_engine(option, option_type, arg_opt)
      print_good = true
      case option_type
      when 'auxiliary'        
        in_focus.datahash[arg_opt] =  option
      when 'payload'
        in_focus.payload.datahash[arg_opt] = option
      when 'exploit'
        in_focus.datahash[arg_opt] = option
      else 
        print_good = false
      end
      
      if (print_good)
        control.prnt_plus("#{arg_opt} => #{option}")
      else
        control.prnt_err("An error occurred setting: #{arg_opt}")
      end 
    end
    
    
    #
    # Process the command 
    #
    def process_set_cmd(cmd)
      cmd.slice!(0)
     return "#{cmd.join(" ")}"         
    end
    
    
    #
    # Process and set an integer value
    #
    def option_integer(cmd)
     val = cmd.to_i
     return val
    end
    
    #
    # Process and set a string value
    #
    def option_string(cmd)
      val = cmd.to_s
      return val
    end
    
    #
    # Process and set an boolean value
    #
    def option_boolean(cmd)
      val = cmd == "true" ? true : false
      return val 
    end
    
    #
    #
    #
    def option_payload(cmd)
      begin
        if ((assistant = framework.modules.load("#{cmd}",control)) == nil)
          if not (in_focus.type.match(/(auxiliary|webserver)/))
            control.prnt_err("Incorrect Payload: #{cmd}")
          else
            control.prnt_err("Incorrect Option (PAYLOAD): #{cmd}")
          end
         return false
        end
                        
        if assistant.type == "payload"
          self.active_assist_module = assistant
        end
      end
                      
      if (active_assist_module) and not (in_focus.type.match(/(auxiliary|webserver)/))
        self.in_focus.payload = self.active_assist_module
        self.in_focus.payload.control = control
        control.prnt_plus(" PAYLOAD => #{cmd}")
      else
       control.prnt_err("Incorrect Payload: #{cmd}")
       return false
      end
    end 
    
    
    attr_accessor :active_assist_module
    
    
   #
   # Tab completion when 'set' something has occurred.
   #
   def arg_set_comp(str, stra)
     list = []
       
     if in_focus.nil? 
       return nil
     elsif stra[1] == "PAYLOAD" and in_focus.type == 'exploit'
       list.concat(framework.modules.module_list)
     elsif stra[1] == "RFI" and in_focus.type == 'exploit'
       list.concat( WXFDB.get_rfi_names.flatten.sort)
     elsif (stra[1] == 'LFILE')
       list.concat(framework.modules.lfile_load_list.keys.sort)
     elsif (stra[1] == 'RURLS')
       list.concat(framework.modules.rurls_load_list.keys.sort)
     elsif (stra[1] == 'UA')
       list.concat(WXf::UA_MAP.keys.sort)
     elsif (stra[1] == 'CONTENT')
       list.concat(WXf::CONTENT_TYPES.keys.sort)
     elsif stra[1] == 'RURL'
       list.concat(POPULAR_URLS)  
     end
       
     case in_focus.type
     when 'exploit'   
       in_focus.options.each {|k,v| list.push(k) and list.push("PAYLOAD")}
       if (in_focus.respond_to?('payload')) and (in_focus.payload.respond_to?('options'))
         in_focus.payload.options.each {|k,v| list.push(k)}   
       end
     else
       in_focus.options.each {|k,v| list.push(k)}
     end 
       return list
   end
    
    
    #
    # Banner is probably obvious, used for displaying a  banner
    #
    def arg_display(*cmd)
      disp =  control.purple(WXf::WXfui::Console::Prints::PrintDisplay.sample + "\n\n")
      disp << " Web Exploitation Framework: #{WXf::Version}\n\n"
      disp << "-{ #{counter("exploits")} exploits }-\n"
      disp << "-{ #{counter("payloads")} payloads }-\n"
      disp << "-{ #{counter("auxiliary")} auxiliary }-\n\n"
      puts disp
    end     
    
 
  #
  # name method is used for controlling the enstacking, destacking
  #
  def name
    "Core"
  end   
  
  #
  # server method is used for setting up the webserver
  # 2010-12-10 --Ken (Bug Fix, added destacking if active_mod exists, updating of prompt,
  # ...pretty printing of the "Manage wXf...")
  #
  def arg_server(*cmd)
    if in_focus()
      arg_back()
    end  
    
    operator = WebserverProcs
    control.add_activity(operator)
    self.in_focus = framework.modules.load("webserver",control)
    control.mod_prm("#{in_focus.type}" + control.red("(config)"))
    control.prnt_gen("Manage wXf web server")
  end
  
  
  #
  # *WILL* be used for importing information in xml format
  # 
  def arg_import(*cmd)
   control.prnt_gen(" This is where we will import thing like a burp xml and maybe nikto responses, who knows")
  end      
    
  

#
# Show options, exploits, payloads....used for all of that 
#     
def arg_show(*cmd)
  activity = self.in_focus
  cmd << "all" if (cmd.length == 0)
     case "#{cmd}"
     when 'all'  
      control.show_payloads
      control.show_auxiliary
      control.show_exploits
              
     when 'exploits'
      control.show_exploits
    
     when 'payloads'
      control.show_payloads
   
     when 'content'
       control.show_content
       
     when 'rurls'
       control.show_rurls  
       
     when 'ua'   
       control.show_ua
       
     when 'lfiles'
       control.show_lfiles      
      
     when 'auxiliary'
      control.show_auxiliary
      
     when 'rfi'
       control.show_rfi
      
     when 'advanced'
       control.show_content
       control.show_lfiles
       control.show_rurls
       control.show_ua 
       control.show_rfi
      
     when 'options'           
      if (activity) 
          control.show_options(activity)
      end
      
     else
       control.prnt_dbg(" The following is a list of accepted show commands:\n")
         arg_show_comp(nil, nil).sort.each do |show_cmd|
           puts("#{show_cmd}\n")
        end  
     end
  end 
  
  
    #
    #
  
 
    #
    # Show tabs helper
    #
    def arg_show_comp(str,stra)
     activity = self.in_focus
     list = []
     if (activity) 
       list = ["exploits","payloads","auxiliary", "options", "lfiles", "ua", "content", "rurls", "advanced", "rfi"]
     else
       list = ["exploits","payloads","auxiliary", "lfiles", "ua", "content", "rurls", "advanced", "rfi"]
     end
    return list 
    end 
   
    
    
    #
    # Shutdown the webserver instances
    #
    def web_shut
      svr_id = 0
        control.webstack.each { |svr|
          control.prnt_gen("Shutting down #{svr.lhost}:#{svr.lport} (#{svr_id})")
          svr_id = svr_id + 1
          svr.shutdown
        }
        control.webstack = []
    end  
      
    #
    # self-explanatory, just exits the framework
    #
    def arg_exit(*cmd)
      #kill webserver processes
      web_shut
      #obvious
      exit
    end
  
    #
    # Getting annoyed by typing ex and then going into EX mode. Srs bzns.
    #
    alias arg_ex arg_exit
    
    #
    # Used to destack the activities
    #
    def arg_back(*cmd)
                      
          if control.activities.length > 1 and control.infocus_activity.name != 'Core'
            
          if (in_focus)
              self.in_focus = nil
          end  
          if (active_assist_module)
              self.active_assist_module = nil
          end      
              control.remove_activity
              control.mod_prm('')
          end
          
    end   
    
    
    
    #
    # This is used for navigating directories
    #
    def arg_cd(*cmd)
      
        if(cmd.length == 0)
            control.prnt_err " No path specified"
            return
        end
        
        begin
            Dir.chdir(cmd.join(" ").strip)
            control.prnt_gen(" pwd: #{Dir.pwd()}")
        rescue ::Exception
            control.prnt_err(" The specified path does not exist")
        end
  
    end

    
    
    
    
    
    
    #
    # Shows arg_help for every operator on the stack that has the method defined.
    #
    def arg_?(*cmd)
            control.activities.each { |operator|
            next if ((operator.respond_to?('avail_args') == false) or
                     (operator.avail_args == nil) or
                     (operator.avail_args.length == 0))
             
                  # Display the commands
                  tbl = WXf::WXfui::Console::Prints::PrintTable.new(
                    'Title'  => "#{operator.name} Commands",
                    'Justify'  => 4,             
                    'Columns' => 
                      [
                        'Command',
                        'Description'
                      ])
            
                  operator.avail_args.sort.each { |k,v|
                  tbl.add_ritems([k.to_s, v.to_s])
                  }
                 tbl.prnt
      }
     
    end
    
      
    #  
    # Method to show version information. *Would like to shift from Core::Version to constants (maybe)
    #
    def arg_version(*cmd)
      control.prnt_gen("Web Exploitation Framework:" + WXf::Version)
    end
 
    
    #
    # Shows current module on the stack, important when troubleshooting bugs. More for us than the user.
    #
    def arg_current(*cmd)
      puts("#{control.infocus_activity}")
    end
     
    
    #
    # A copy of the method arg_?
    # 
    alias arg_help arg_?
    
    
    #
    # A copy of the method arg_info_comp
    #
    def arg_info_comp(str, stra); arg_use_comp(str, stra); end
    
    #
    # Thanks to CG [carnal0wnage] for mentioning this method. 
    # ...Returns information on a module
    #
    def arg_info(*cmd)
       arg_name = cmd[0]
       
       if cmd.length == 0 and in_focus.nil?
         print(
                   "Example: info <module name>\n\n")
                   return false
       end
      
       if (cmd.length == 0) and (in_focus)
         if in_focus.type.match(/(auxiliary|exploit)/)
            WXf::WXfui::Console::Prints::PrintPretty.collect(in_focus)
         end
      end
      
      
      if (cmd.length >= 1)
        if ((mod = framework.modules.load(arg_name, control)) == nil)
                  control.prnt_err(" Non-existent module: #{arg_name}")
                return false
        else
          WXf::WXfui::Console::Prints::PrintPretty.collect(mod)
        end
      end
      
    end
  
  
  
  #
  # Used to reload an object
  #
  def arg_reload(*cmd)
    item = "#{cmd[0]}"     
    unloaded = false
    type_name = ''
    if in_focus
      type_name = in_focus.type
    end
        
    case item
      when "current" 
        if !in_focus
          control.prnt_err("There is no module in use")    
          return
        end
        if type_name.match(/(auxiliary|exploit|payload)/)
          name = ''
          mods = framework.modules.mod_pair[type_name]
            mods.each {|k,v| 
              if v == in_focus
                name = k
              end
            }
        full_name = "#{type_name}/#{name}"
        framework.modules.reload(in_focus, full_name)
        arg_use(full_name)
        web_shut
       elsif type_name.match(/webserver/)
         web_shut
         arg_server
       else
         unloaded = true
         control.prnt_err("The current activity in use cannot be reloaded")
       end     
      when "lfiles"
        framework.modules.reload("lfiles")
      when "rurls"
        framework.modules.reload("rurls")
      when "modules"
        # Reset everything
        framework.modules.mod_load(WXf::ModWorkingDir)
        web_shut
        arg_back   
      when "all"
        web_shut
        framework.modules.mod_load(WXf::ModWorkingDir)
        framework.modules.reload("lfiles")
        framework.modules.reload("rurls")
        arg_back       
      else
        unloaded = true
        control.prnt_dbg(" The following is a list of accepted reload commands:\n")
          arg_reload_comp(nil, nil).sort.each do |cmd|
          puts("#{cmd}\n")
      end
    end
     
    if unloaded == false
      control.prnt_gen("Reloaded: #{item}")
    end
  end
  
  
  #
  # Tab completion of the reload command
  #
  def arg_reload_comp(str, stra)
    list = []
    if (self.in_focus)
      list = ["lfiles", "rurls", "current", "modules", "all"]
    else
      list = ["lfiles", "rurls", "modules", "all"]
    end
   return list
  end  
 
    
    ### I'd like to move this over to the module factory/loader as a way to organize our payloads, exploits
    ### Just ref the method created under that class and return the result. Servers dual purposes.
    
    def counter(arg)
      count = 0
     case arg
     when "exploits"
      list = framework.modules.counter('exploit')
     when "payloads"
       list = framework.modules.counter('payload')
     when 'auxiliary'
       list = framework.modules.counter('auxiliary')
     end 
      return list 
    rescue
    end
      
  
  
  def avail_args
    {
        
        "?"        => "Help menu",
        "back"     => "Move back from the current context",
        "display"   => "Displays the banner artwork to a user",
        "cd"       => "Change Directory",      
        "current"  => "Displays the current activity of focus within the stack",
        "ex"       => "Exit the console (shortcut)",
        "exit"     => "Exit the console",
        "help"     => "Help menu",
        "import"   => "Imports a user provided file",
        "info"     => "Displays info about one or more module",
        "reload"   => "Reload rurls and lfiles lists",
        "server"   => "Setup a local webserver",
        "set"      => "Sets a variable to a value",
        "show"     => "Displays modules of a given type",
        "update"   => "Upates the framework",
        "use"      => "Selects an exploit by name",
        "version"  => "Show the framework and console library version numbers",
           
        }
  end
  
  
end

end end end end