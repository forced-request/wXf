#
# Class used to call the db, create an instance of an exploit and run
#


module WXf
module WXfconductors
  
  class Webserver_Conductor
    
    attr_accessor :options, :desc, :exp, :pay, :webstack
    
    def initialize(control)
      @control = control
      self.exp = nil
      self.pay = nil
      self.webstack = @control.webstack
      
      self.options = {
          "LHOST" => "127.0.0.1",
          "LSECURE" => "false",
          "LPORT" => 8888,
          "LPATH" => "/",
          "LFILE" => nil,
          "LCONTENTTYPE" => "text/html",
          "LCUSTOMHEADER" => nil,
          "LHTML" => nil
        }
        
        self.desc = {
          "LHOST" => "hostname or ip",
          "LSECURE" => "ssl enabled (not yet supported)",
          "LPORT" => "port to listen on",
          "LPATH" => "path for file on webserver",
          "LFILE" => "local file to load (use LFILE or LHTML)",
          "LCONTENTTYPE" => "content-type to serve up",
          "LCUSTOMHEADER" => "any custom header to send",
          "LHTML" => "raw txt (html/javascript) to respond with"
        }
     
    end
    
  def dis_required_opts
    # Display the commands
    tbl = WXf::WXfui::Console::Prints::PrintTable.new(
    'Output' => @control.output,
    'Justify'  => 4,             
    'Columns' => 
    [
    'Name',
    'Current Setting',
    'Description',
                           
     ])
     self.options.each { |k,v|
     if (!v)
     v = ""
     end
     tbl.add_ritems([k.to_s,v.to_s, self.desc[k].to_s ])
     }
     tbl.prnt
     
  end
  
  def usage
    $stderr.puts("\n"+"Webserver options:")
    dis_required_opts  
  end
    
    #
    # Defines the type of module
    #
    def type
      WEBSERVER
    end
    
  end
  
  
end
end