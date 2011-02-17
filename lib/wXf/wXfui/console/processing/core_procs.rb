#Important to call wAx here
require 'wAx'

module WXf
module WXfui
module Console
module Processing


class CoreProcs
 
  attr_accessor :control, :framework, :exploit_opts, :svr
 
 include WXf::WXfui::Console::Operations::ModOperator
 
      def initialize(control)
      super
            self.control = control
            self.framework =  control.framework
      end

      
    #   
    # When the user types "use" a decision has to be made. 
    # This will help us initialize modules such as exploits, payloads.  
    #
    def arg_use(*cmd)
     
      if (cmd.length == 0)
        print(
           "Usage: use module_name\n\n" +
           "The use command is used to interact with a module of a given name.\n")
           return false
      end 
      
      arg_name = cmd[0]
      
      begin
        if ((single_module = framework.modules.load(arg_name, control)) == nil)
          control.prnt_err(" Failed to load module: #{arg_name}")
        return false
        end
        rescue NameError => info
        control.prnt_err("The supplied module name is ambiguous: #{$!}.")
        return false if (single_module == nil)
      end      
            operator = nil
            
            case single_module.type
            when DB_EXP
               operator = DbExploitProcs
            when FILE_EXP
               operator = FileExpProcs   
            when AUXILIARY
              operator = AuxiliaryProcs
           else
              control.prnt_err(" Failed to load module: #{arg_name}\n\n"+
                                 "Please ensure you are not trying to use a Payload")
               return false
        end
        
        #If we already have an active module we need to destack it
        if active_module()
         arg_back()
         end
      
        # If operator was a valid stack activity type then stack that puppy
        if (operator != nil)
          control.enstack_operator(operator)
        end
        
        # Update the active module
        self.active_module = single_module  
        #Update the prompt
        
        if auxiliary? or file_exploit?
          #short term workaround
          nickname = arg_name.split('/')
          control.update_prompt("#{single_module.type}" + control.red("(#{nickname.last})", true))
        else
          control.update_prompt("#{single_module.type}" + control.red("(#{arg_name})", true))
        end
             
    end
    
    
    #
    #These will get shifted around eventually, for now they lighten the load on if/elsif/else type programming
    #
    def auxiliary?
     active_module.type == 'auxiliary'
    end
        
    def file_exploit?
      active_module.type == 'file_exploit'
    end
    
    
    #
    # Use tab helper
    #
    def arg_use_tabs(str, stra)
     mods = framework.modules.module_list
     return mods
    end
    
    #
    # Suppots the decision making process of which options to set with arg_set.
    #
    def option_name(cmd)
        name_of_opt = cmd
        opt = nil
        
        if (active_module.type == WEBSERVER) and (active_module.options.has_key?(name_of_opt))
          opt = 'webserver_options'
        elsif (active_module.type == CREATE_EXPLOIT) and (active_module.options.has_key?(name_of_opt))
          opt = 'create_exploit_options'
        elsif (active_module.type == CREATE_PAYLOAD) and (active_module.options.has_key?(name_of_opt))
          opt = 'create_payload_options'
        elsif (active_module.type == AUXILIARY) and (active_module.options.has_key?(name_of_opt))
          opt = 'auxiliary_options' 
        elsif (active_module.type == FILE_EXP) and (active_module.options.has_key?(name_of_opt))  
          opt = 'exploit_mod_options'
        elsif (active_module.respond_to?('pay')) and (active_module.pay.respond_to?('options')) and (active_module.pay.optional.has_key?(name_of_opt))
         opt = 'optional_payload'
        elsif (active_module.respond_to?('pay')) and (active_module.pay.respond_to?('required')) and (active_module.pay.required.has_key?(name_of_opt))
          opt = 'required_payload'
        elsif (active_module.respond_to?('exp')) and (active_module.exp.respond_to?('optional')) and (active_module.exp.optional.has_key?(name_of_opt))
          opt = 'optional_exploit'
        elsif (active_module.respond_to?('exp')) and (active_module.exp.respond_to?('required')) and (active_module.exp.required.has_key?(name_of_opt))
          opt = 'required_exploit'
        elsif (name_of_opt == "PAYLOAD")  
          opt = 'PAYLOAD'
        else
          control.prnt_err(" Please enter a valid option, use show options") 
          return false
        end
        
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
   
      if (active_module) and not (cmd[1].nil?)
          case option_name(cmd[0])    
              when  'optional_payload'
                     cmd.slice!(0)
                     active_module.pay.optional[arg_opt] = "#{cmd.join(" ")}"       
              when  'required_payload'
                     cmd.slice!(0)
                     active_module.pay.required[arg_opt] = "#{cmd.join(" ")}"
              when  'optional_exploit'     
                     cmd.slice!(0)
                     active_module.exp.optional[arg_opt] = "#{cmd.join(" ")}"
              when  'required_exploit'
                     cmd.slice!(0)
                     active_module.exp.required[arg_opt] = "#{cmd.join(" ")}"
              when  'auxiliary_options' 
                     cmd.slice!(0)
                     active_module.datahash[arg_opt] = "#{cmd.join(" ")}"  
              when  'exploit_mod_options'
                     cmd.slice!(0)
                     active_module.datahash[arg_opt] = "#{cmd.join(" ")}"   
              when  'webserver_options'
                     cmd.slice!(0)
                     active_module.options[arg_opt] =  "#{cmd.join(" ")}"
              when 'create_exploit_options'
                     cmd.slice!(0)
                     active_module.options[arg_opt] = cmd.join(" ")
              when 'create_payload_options'
                     cmd.slice!(0)
                     active_module.options[arg_opt] = cmd.join(" ")   
              when  'PAYLOAD'
                     begin
                     
                     if ((assistant = framework.modules.create("#{cmd[1]}",control)) == nil)
                       return false
                     end
                        return false if (assistant == nil)
                        self.active_assist_module = assistant.payload 
                     end
                    
                      if (active_assist_module) and not(active_module.type == 'auxiliary')
                          self.active_module.pay = self.active_assist_module
                          control.prnt_plus(" PAYLOAD => #{cmd[1]}")
                     else
                          control.prnt_err(" Incorrect Payload #{cmd[1]}")
                          return false
                      end
            end       
        end  
    end  
    
    
    attr_accessor :active_assist_module
    
    
    #
    #
    #
    def arg_set_tabs(str, stra)
      list = []
        
      if active_module.nil? 
        return nil
      elsif stra[1] == "PAYLOAD" and active_module.respond_to?('exp')
        list.concat(framework.modules.payload_array)
      elsif (stra[1] == 'LFILE') and (active_module) and (active_module.type == 'webserver')
        list.concat(framework.modules.lfile_load_list.keys.sort)
      elsif stra[1] == 'RURL'
        list.concat(POPULAR_URLS)  
      end
        
      case active_module.type
      when 'db_exploit'   
        active_module.exp.options.each {|k,v| list.push(k) and list.push("PAYLOAD")}
        if (active_module.respond_to?('pay')) and (active_module.pay.respond_to?('options'))
          active_module.pay.options.each {|k,v| list.push(k)}   
        end
      else
        active_module.options.each {|k,v| list.push(k)}
      end 
        return list
    end
    
    
    #
    # Banner is probably obvious, used for displaying a  banner
    #
    def arg_display(*cmd)
      disp =  control.purple(WXf::WXfui::Console::Prints::PrintDisplay.to_s + "\n\n")
      disp << "------{ "
      disp << "Web Exploitation Framework: #{WXf::WXfdb::Core::Version}\n"
      disp << "------{ "
      disp << "#{counter("db_exploit")} db exploits\n"
      disp << "------{ "
      disp << "#{counter("db_payload")} payloads\n"
      disp << "------{ "
      disp << "#{counter("file_exploit")} file exploits\n"
      disp << "------{ "
      disp << "#{counter("auxiliary")} auxiliary\n\n"
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
    if active_module()
      arg_back()
    end  
    
    operator = WebserverProcs
    control.enstack_operator(operator)
    self.active_module = framework.modules.create("webserver",control)
    control.update_prompt("#{active_module.type}" + control.red("(config)"))
    control.prnt_gen(" Manage wXf web server")
  end
  
  
  
  
  #
  # create method for adding new exploits and payloads to the database
  # KEN - TODO: Lets get this moved into the webserver_conductor.rb or webserver.rb
  #
  def arg_create(*cmd)
    if (cmd[0] =~ /exploit/)
      control.prnt_gen(" Create new exploit")
      operator = Create_Exploit
      control.enstack_operator(operator)
      self.active_module = framework.modules.create("create_exploit",control)
      control.update_prompt("#{active_module.type}" + control.red("(create)"))
    elsif (cmd[0] =~ /payload/)
     control.prnt_gen(" Create new payload")
      operator = Create_Payload
      control.enstack_operator(operator)
      self.active_module = framework.modules.create("create_payload",control)
      control.update_prompt("#{active_module.type}" + control.red("(create)"))
    else
      control.prnt_err(" Specify 'exploit' or 'payload' for creation")
    end
  end
  
  
  def arg_create_tabs(str, stra)
    list = ["exploit", "payload"]
    return list
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
    single_module = self.active_module
    cmd << "all" if (cmd.length == 0)
       case "#{cmd}"
       when 'all'  
        show_exploits_db
        show_payloads 
        show_auxiliary
        show_exploits_mods
        show_lfiles
        show_global_options
                
       when 'exploits_db'
        show_exploits_db
        
       when 'exploits_mod'
        show_exploits_mods  
      
       when 'payloads'
        show_payloads
        
       when 'payload_mod'
     #    show_payload_mods   
         
       when 'lfiles'
         show_lfiles      
        
       when 'auxiliary'
        show_auxiliary
        
       when 'options'           
        if (single_module) 
            show_options(single_module)
        else 
          show_global_options  
        end
        
      end
   
    end 
  
    
 
    
    #
    # Show tabs helper
    #
    def arg_show_tabs(str,stra)
     list = ["exploits_db","payloads","auxiliary", "options", "exploits_mod", "lfiles"]
    return list 
    end 
   
    
    
    
    #
    # self-explanatory, just exits the framework
    #
    def arg_exit(*cmd)
      svr_id = 0
      control.webstack.each { |svr|
        control.prnt_gen("Shutting down #{svr.lhost}:#{svr.lport} (#{svr_id})")
        svr_id = svr_id + 1
        svr.shutdown
      }
      exit
    end
  
    
    
    #
    # Used to destack the operator_stack
    #
    def arg_back(*cmd)
         
          if control.operator_stack.size > 1 and
              control.current_operator.name != 'Core'
          if (active_module)
              self.active_module = nil
          end  
          if (active_assist_module)
              self.active_assist_module = nil
          end      
              control.destack_operator
              control.update_prompt('')
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
    # When an active_module exists this method becomes the de-facto to module specific options
    #
    def show_options(single_module)
    
     case single_module.type
     when 'db_exploit'
      single_module.exp.usage
        if (single_module.pay)
            single_module.pay.usage
        end
            
     when 'db_payload'
      single_module.payload.usage
     when 'file_exploit'
       single_module.usage
     when 'auxiliary'
       single_module.usage
     when 'webserver'
       single_module.usage
     when 'create_exploit'
       single_module.usage
     when 'create_payload'
       single_module.usage
     end
       
    end
 
    
    
    #
    # Shows arg_help for every operator on the stack that has the method defined.
    #
    def arg_?(*cmd)
            control.operator_stack.reverse.each { |operator|
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
      control.prnt_gen("Web Exploitation Framework:" + WXf::WXfdb::Core::Version)
    end
 
    
    #
    # Shows current module on the stack, important when troubleshooting bugs. More for us than the user.
    #
    def arg_current(*cmd)
      puts("#{control.current_operator}")
    end
     
    
    #
    # Whether the user chooses ? or help it won't matter, arg_? will be invoked
    # 
    alias arg_help arg_?
    alias arg_info_tabs arg_use_tabs
    
    
    #
    # Thanks to CG [carnal0wnage] for mentioning this method. 
    # ...Returns information on a module
    #
    def arg_info(*cmd)
       arg_name = cmd[0]
       
       if cmd.length == 0 and active_module.nil?
         print(
                   "Usage: info module1 module2 module3 ...\n\n" +
                   "Queries the supplied module or modules for information.\n")
                   return false
       end
      
       if (cmd.length == 0) and (active_module)
         case active_module.type
         when 'auxiliary'
            WXf::WXfui::Console::Prints::PrintPretty.collect(active_module)
         end
      end
      
      
      if (cmd.length >= 1)
        if ((mod = framework.modules.create(arg_name, control)) == nil)
                  control.prnt_err(" Non-existent module: #{arg_name}")
                return false
        else
          WXf::WXfui::Console::Prints::PrintPretty.collect(mod)
        end
      end
      
    end
  
 #####################################
 #  BEGIN EXPLOIT EXISTENCE CHECK & LIST
 #####################################
  
  #
  #
  #
  def wXflist_call 
      WXf::WXfdb::Core.new(WXFDIR, 1)
  end
  
  
   #
   #
   #
   def exploit_list_by_name(args)
      wXflist_call.db.get_exploit_by_name(args)
   end
   
   
   #
   #
   #
   def show_exploits_db
       list = wXflist_call.db.get_exploit_list
   opts = {}
                str = ''
               
                    # Display the commands
                    tbl = WXf::WXfui::Console::Prints::PrintTable.new(
                      'Title'  => "Database Exploits",
                      'Justify'  => 4,             
                      'Columns' => 
                        [
                          'Name',
                          'Description'
                        ])
              
                    list.each { |id,name, desc|
                      tbl.add_ritems([name, desc])                      
                    }
                      tbl.prnt
                    
    end
  
    
    ### I'd like to move this over to the module factory/loader as a way to organize our payloads, exploits
    ### Just ref the method created under that class and return the result. Servers dual purposes.
    
    def counter(arg)
      count = 0
     case arg
     when "db_exploit"
      list = wXflist_call.db.get_exploit_list.count
     when "db_payload"
       list = wXflist_call.db.get_payload_list.count
     when 'auxiliary'
       list = framework.modules.counter('auxiliary')
     when 'file_exploit' 
       list = framework.modules.counter('file_exploit')
     when 'file_payload'
       list = framework.modules.count('file_payload')
     end 
      return list 
    rescue
    end
    
  
  #####################################
  #  BEGIN PAYLOAD EXISTENCE CHECK & LIST
  #####################################
  
  def payload_list_by_name(args)
        wXflist_call.db.get_payload_by_name(args)
  end
    
  
  #
  # Shows payloads
  # 
  def show_payloads 
         list = wXflist_call.db.get_payload_list
              # Display the commands
              tbl = WXf::WXfui::Console::Prints::PrintTable.new(
                'Title'  => "Payloads",
                'Justify'  => 4,             
                'Columns' => 
                [
                  'Name',
                    'Description'
                  ])
                    
                    list.each { |id,name, desc|
                    tbl.add_ritems([name, desc])
    }
                    tbl.prnt
      end
  
    
  #
  # Show auxiliary mods
  #    
  def show_auxiliary
   list = framework.modules.mod_pair['auxiliary'].mods_fn_list
                          # Display the commands
                          tbl = WXf::WXfui::Console::Prints::PrintTable.new(
                            'Title'  => "Auxiliary",
                            'Justify'  => 4,             
                            'Columns' => 
                              [
                                'Name',
                                'Description'
                              ])
                    
                          list.each {|name|
                            tbl.add_ritems([name])
                            }
                         tbl.prnt
  end
  
  
  # 
  # Show exploit modules
  #
  def show_exploits_mods
   list = framework.modules.mod_pair['file_exploit'].mods_fn_list
                          # Display the commands
                          tbl = WXf::WXfui::Console::Prints::PrintTable.new(
                            'Title'  => "Exploit Modules",
                            'Justify'  => 4,             
                            'Columns' => 
                              [
                                'Name',
                                'Description'
                              ])
                    
                          list.each {|name|
                            tbl.add_ritems([name]) 
                            }
                         tbl.prnt
  end
  
  
  #
  # Show lfiles
  #
  def show_lfiles
       list = framework.modules.lfile_load_list
                              # Display the commands
                              tbl = WXf::WXfui::Console::Prints::PrintTable.new(
                                'Title'  => "Local Files",
                                'Justify'  => 4,             
                                'Columns' => 
                                  [
                                    'Name',
                                    'Description'
                                  ])
                        
                              list.each {|name, path|
                                tbl.add_ritems([name]) 
                                }
                             tbl.prnt
  end
  
  #
  # Show global options
  #
  def show_global_options
    control.prnt_gen(" wXf - Global Options Coming Soon, try typing: show")
  end
  
  
  def avail_args
    {
        
        "?"        => "Help menu",
        "back"     => "Move back from the current context",
        "display"   => "Displays the banner artwork to a user",
        "cd"       => "Change Directory",
        "create"   => "Create an 'exploit' or 'payload'",
        "current"  => "Displays the current activity of focus within the stack",
        "exit"     => "Exit the console",
        "help"     => "Help menu",
        "import"   => "Imports a user provided file",
        "info"     => "Displays info about one or more module",
        "server"   => "Setup a local webserver",
        "set"      => "Sets a variable to a value",
        "show"     => "Displays modules of a given type",
        "use"      => "Selects an exploit by name",
        "version"  => "Show the framework and console library version numbers",
        
        }
  end
  
  
end

end end end end