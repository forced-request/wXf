#!/usr/bin/env jruby

require 'rubygems'
require "xmlrpc/client"

class Net::HTTP
  alias_method :old_initialize, :initialize
  def initialize(*args)
    old_initialize(*args)
    @ssl_context = OpenSSL::SSL::SSLContext.new
    @ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end
end

class XmlRpcClient

  def initialize
    @server = ::XMLRPC::Client.new("127.0.0.1", "/", 9000, nil, nil, 'cktricky', 'toor', true)
    @server.instance_variable_get(:@http).instance_variable_set( :@verify_mode, OpenSSL::SSL::VERIFY_NONE )
  end
  
  def run(cmd)
    begin
      @server.call("wxfapi.cmd", "#{cmd}")
    rescue Exception => e
      #stub
    end
  end
  
  def view_desc(mod)
    begin
      @server.call("wxfapi.cmd", "info #{mod}")
      rescue Exception => e
       #stub       
    end
  end
  
  def send_to_console(mod)
    begin
      @server.call("wxfapi.cmd", "use #{mod}")
      rescue Exception => e
       #stub       
    end
  end

end