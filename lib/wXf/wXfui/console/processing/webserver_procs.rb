module WXf
module WXfui
module Console
module Processing
  
  class WebserverProcs
     include WXf::WXfui::Console::Operations::ModuleCommandOperator
     
     def name
       "WebserverProcs"
     end
     
     
     def avail_args
      {
             "start"   => "starts the server",
             "stop"    => "stops the webserver #",
             "list"    => "list current webservers",
             "desc"    => "describe details of server #",
             "select"  => "select server to manage",
       }
     end
     
     
     # Ken says - Seth, I've added the control as a parameter when initializing the webserver.
     # We need to be able to invoke framework.modules.lfile_list_load for automagic fun
     # regarding LFILE.
     def arg_start(*cmd)  
       if (active_module.type == WEBSERVER)
         opts = active_module.options
         control.prnt_plus(" Starting webserver at #{opts["LHOST"]}:#{opts["LPORT"]}")
         
         if (!opts["LFILE"] and !opts["LHTML"])
           puts " => LFILE or LHTML must be set before starting the webserver"
         elsif (opts['LHTML'])
           begin
             svr = WXf::WXfwebserver::WebServer.new(opts, control)
             control.enstack_webstack(svr)
             servlet_opts = {
               "LHTML" => opts['LHTML'],
               "TXT" => nil,
               "LCONTENTTYPE" => opts['LCONTENTTYPE'],
               "LFILE" => opts['LFILE']
             }
             servlet = WXf::WXfwebserver::Configurable
                 
             svr.add_servlet(opts['LPATH'], servlet, servlet_opts)
                 
             svr.start
           rescue
             print "[wXf] Error when starting the webserver: #{$!}\n"
           end
         elsif(opts['LFILE'])
           begin
             svr = WXf::WXfwebserver::WebServer.new(opts,control)
             control.enstack_webstack(svr)
             svr.add_file(opts)
             svr.start
           rescue
             print "[wXf] Error when starting the webserver: #{$!}\n"
           end
         end
       end
       reset()
     end
     
     
     #
     # Resets the LHTML and LFILE attributes so that we start fresh after an activity has been launched
     #
     def reset()
         active_module.options['LHTML'] = nil
         active_module.options['LFILE'] = nil 
     end
     
     
     # 
     # Stops the current webserver on the stack
     #
     def arg_stop(*cmd)
       
       if ( cmd[0] != nil )
         svr_id = cmd[0].to_i
      
         svr = control.webstack[svr_id]
       
       
         if (svr)
           puts "Stopping the webserver (#{svr_id}) at #{svr.lhost}:#{svr.lport}"
      
           svr.shutdown
           control.destack_webstack(svr_id)
         else
           puts "No server with id #{svr_id}"
         end
         
       else
         puts "[wXf] Stopping all webservers"
         svr_id = 0
         control.webstack.each { |svr|
           print "[wXf] Shutting down #{svr.lhost}:#{svr.lport} (#{svr_id})\n"
           svr_id = svr_id + 1
           svr.shutdown
           control.destack_webstack(0)
         }
       end

     end
     
     
     #
     # Provides a description
     #
     def arg_desc(*cmd)
       svr_id = cmd[0].to_i
       svr = control.webstack[svr_id]
       if (svr)
                      
         # Display the commands
         tbl = WXf::WXfui::Text::Table.new(
           'Justify'  => 4,             
           'Columns' => 
             [
               'Name',
               'Current Setting'
             ])
                     
         tbl.add_ritems(["LHOST",svr.lhost.to_s])
         tbl.add_ritems(["LPORT",svr.lport.to_s])
         tbl.add_ritems(["LSECURE",svr.lsecure.to_s])
         tbl.add_ritems(["LPATH",svr.lpath.to_s])
         tbl.add_ritems(["LFILE",svr.lfile.to_s])
         tbl.add_ritems(["LHTML",svr.lhtml.to_s])
         tbl.add_ritems(["LCONTENTTYPE",svr.lcontenttype.to_s])
         tbl.add_ritems(["LCUSTOMHEADER",svr.lcustomheader.to_s])
           
          tbl.prnt
         
       else
         puts "No server with id #{svr_id}"
       end
     end
     
     
     #
     # Lists the webservers running on the stack
     #
     def arg_list(*cmd)
       puts "Running webservers"
       puts "------------------"
       id = 0
       control.webstack.each { | svr |
         puts "(#{id}) #{svr.lhost}:#{svr.lport} #{svr.lcontenttype} #{svr.lfile}"
         id = id + 1
       }
     end
     
     
     #
     # Selects an activity/instance to interact with
     #
     def arg_select(*cmd)
       puts "Managing instance #{cmd[0]}"
     end
     

        
  end  
     
end end end end  