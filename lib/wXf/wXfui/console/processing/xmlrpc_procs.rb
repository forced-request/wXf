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
      end
      
      def arg_stop(*cmd)
      end 
  
  end 
  
end end end end