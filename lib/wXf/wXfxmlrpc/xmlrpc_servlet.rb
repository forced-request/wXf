require 'xmlrpc/server'
require "webrick"
require 'base64'

module WXf
  module WXfXmlRpc


  class XmlRpcServlet < ::XMLRPC::WEBrickServlet
    
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



end end 
