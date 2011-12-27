require 'xmlrpc/server'
require "webrick"
require 'base64'

module WXf
module WXfui
module Console
module Processing
  
  class XmlRpcHandler
  
  end
  
  class XmlRpcServlet < XMLRPC::WEBrickServlet
    
    def initialize(user, pass)
      @user = user
      @pass = pass
      super()
    end
  
    def service(*args)
      req, resp = args
      auth_header = req.header['authorization']
      
      if auth_header !=nil && auth_header.length > 0
        # Pass in a string
        val = auth_check("#{auth_header}")
      end 
      
      if val
        super(*args)
      else
        raise WEBrick::HTTPStatus::Unauthorized
      end 
    end
  
    def auth_check(creds)
      if @user.length > 0 && @pass.length > 0
        real_creds = creds.to_s.split
    
        # Get the creds
        if real_creds[0] == "Basic"
          u, p = Base64.decode64("#{real_creds[1]}").split(':')[0..1]
        end
    
        # Run a check of the creds
        if u == @user && @pass = p
          return true
        else
          return false
        end 
      else
        raise WEBrick::HTTPStatus::Unauthorized
      end
    end
 
  end
  
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
          user = opts['user']
          pass = opts['pass']
          port = opts['port']
          # Error checking
          control.prnt_err("Enter a username and password") and return unless user.length > 0 && pass.length > 0
          
        end 
      end
      
      def arg_stop(*cmd)
      end 
  
  end 
  
end end end end