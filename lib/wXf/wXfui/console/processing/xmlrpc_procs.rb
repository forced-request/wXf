module WXf
module WXfui
module Console
module Processing 
  
  class XmlRpcProcs
    include WXf::WXfui::Console::Operations::ModuleCommandOperator
    
      def name
        "xmlrpc"
      end
     
      def avail_args
        {
          "start"   => "starts the server",
          "stop"    => "stops the webserver #",
        }
      end
     
      def arg_start(*cmd)
        if (in_focus.type == XMLRPC)
          opts = in_focus.options
          user = opts['USER']
          pass = opts['PASS']
          port = opts['PORT']
          # Error checking
          if user.length > 0 && pass.length > 0            
            if control.xmlrpc_servers.length == 0
              @servlet = WXf::WXfXmlRpc::XmlRpcServlet.new(user, pass)
              @servlet.add_handler("wxfapi", WXf::WXfXmlRpc::XmlRpcApi.new)
              @server = WXf::WXfXmlRpc::XmlRpcServer.new(control, port)
              @server.mount("/", @servlet)
              @server.start_server
              control.xmlrpc_servers.push(@server)
            else
              control.prnt_err("Please stop the already running server, type: stop")
            end
          else
            control.prnt_err("Enter a username and password")
          end 
        end 
      end
      
      def arg_stop(*cmd)
       
       if @server == nil
          control.prnt_dbg("There is no running xmlrpc server to stop")
          return
       end
        @server.stop_server
        control.xmlrpc_servers.pop
        @server = nil
      end 
  
  end 
  
end end end end