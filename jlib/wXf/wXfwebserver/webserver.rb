# webserver.rb
# Part of the core module, a harness for creating a webserver to serve up payloads and exploits
# 
# created 2010-09-28 by seth
#

require 'webrick'
include WEBrick

module WXf
module WXfwebserver
    
class WebServer
  
  attr_accessor :server, :pid, :lhost, :lport, :lsecure, :lpath, :lfile, :lcontenttype, :lcustomheader, :lhtml
    
    def initialize (opts, control)
     init_validation(opts, control)
    end
    
    
    def init_validation(opts, control) 
            self.lhost = opts["LHOST"] || '127.0.0.1'
            self.lport = opts["LPORT"] || '8888'
            self.lsecure = opts["LSECURE"]
            self.lpath = opts["LPATH"]
            self.lcontenttype = opts["LCONTENTTYPE"]
            self.lcustomheader = opts["LCUSTOMHEADER"]
           
            if (empty_val?(opts["LHTML"]) == true)
             else
              self.lhtml = opts["LHTML"]
            end
            
            if (empty_val?(opts["LFILE"]) == true)
              else
                self.lhtml = opts["LFILE"]
            end
            
            
            #We need to begin to verify if this matches a hash value stored  
              if control.framework.modules.lfile_load_list.has_key?(opts["LFILE"])
               inst = opts["LFILE"]
               name = control.framework.modules.lfile_load_list[inst]
               self.lfile = name
             else
               self.lfile = opts["LFILE"]
             end
            self.server = HTTPServer.new(:Address => self.lhost, :Port => self.lport)
    end
    
    
    #
    #
    #
    def empty_val?(opt)
      @opt == opt.nil? or (opt.to_a.length == 0)
    end
    
    
    #
    # Created a self.pid instance so that the shudown method can invoke a kill on the pid
    #
    def start
      self.pid = fork do
          server.start
      end
    end
  
  
    # 
    # This provides a means of interacting with svr to provide on-the-fly content
    #
    def add_servlet (path,servlet, opts)
      self.lpath = path
      self.lhtml = opts['LHTML']
      server.mount(path,servlet, opts)
    end
    
    
    #
    #
    #
    def add_file(opts)
        self.lpath = opts['LPATH'] 
        server.mount(self.lpath,HTTPServlet::FileHandler,self.lfile)
    end
    
    
    #
    # Means of killing the process ID associated with our server instance and then shutting down the server
    #   
    def shutdown
      Process.kill("KILL", self.pid)
      server.shutdown
    end
    
end



  class WXfServlet < WEBrick::HTTPServlet::AbstractServlet
    
    def do_GET(request, response)
      status, content_type, body = render(request)
      if ( status == 404 )
            raise HTTPStatus::NotFound
      else
            response.status = status
            response['Content-Type'] = content_type
            response.body = body
      end
    end
    
  end
  
  
  
  class Configurable < WXfServlet
    
    attr_accessor :content, :contenttype, :file, :txt
    
    def initialize(server, opts)  
      super(server)
      self.content = opts['LHTML']
      self.contenttype = opts['LCONTENTTYPE']
      self.txt = opts['TXT']
      self.file = opts['LFILE']
    end
    
    
    #
    # Render stuff :-)
    #
    def render(request)
        if (self.file)
              c = ''
              File.open(self.file,"rb") { |file|
              c = c + "#{file}"
              }
        if ( c.length > 0 )
              return 200, self.contenttype, c
        else
              return 404, nil, nil
        end
        elsif (self.content)
        if ( self.content =~ /<#>TXT<%>/ )
            self.content.gsub!(/<#>TXT<%>/,self.txt)
        end
            return 200,  self.contenttype, self.content
        else
            return 404, nil, nil
        end
     end
  end

end end