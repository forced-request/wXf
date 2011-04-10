require 'wXf/wXfui'

begin
  require 'rubygems'
rescue LoadError
end

module WXf
module WXfassists
module General
module MechReq

  include WXf::WXfui::Console::Prints::PrintSymbols      
      attr_accessor :rce
      
      #
      # Global Options are created
      #
      def initialize(hash_info={})
          super
            init_opts([
              WXf::WXfmod_Factory::OptString.new('RURL',   [true, 'Target address', 'http://www.example.com/test.php']),
              WXf::WXfmod_Factory::OptInteger.new('PROXYA', [false, 'Proxy IP Address', '']),
              WXf::WXfmod_Factory::OptString.new('PROXYP', [false, 'Proxy Port Number', '']),
           ])
     end
     
     
     def rurl
      datahash['RURL']
     end
     
     def proxyp
      datahash['PROXYP']
     end
     
     def proxya
       datahash['PROXYA']
     end
=begin       
      # [RURL]
      # [PROXYA]
      # [PROXYP]
      # [DEBUG]
      # [UA]
      # [BASIC_AUTH_USER]
      # [BASIC_AUTH_PASS]
      # [GET, POST, PUT, HEAD, DELETE]
      # [RFILE]
      # [RFILECONTENT]
      # [CAFILE]
      # [KEEP-ALIVE]
      # [RPARAMS]
      # [HEADERS]
      # [REDIRECT]


   all agent methods
  
  #add_to_history
  #auth
  #back
  #basic_auth
  #click
  #cookies
  #current_page
  #delete
  #fetch_page
  #get
  #get_file
  #head
  #log
  #log=
  #max_history
  #max_history=
  #page
  #post
  #post_connect_hooks
  #post_form
  #pre_connect_hooks
  #put
  #request_with_entity
  #resolve
  #set_proxy
  #submit
  #transact
  #user_agent_alias=
  #visited?
  #visited_page 
    
=end        
      
     
    
      #
      # An agent object is instantiated (Mechanize) and debugging is determined
      #
      def mech_req(opts={})
        debug = opts['DEBUG']
        agent = nil
        
        begin
          case debug
          # This represents output to the console  
          when 'console'
            agent = WAx::WAxHTTPLibs::Mechanize.new {|a|  a.log = Logger.new(STDERR)}
          # This represents writing to agent.log in the logs directory
          when 'log'
          file = "#{LogsDir}agent.log"
          if File.exist?(file)
            File.delete(file)
          end
            agent = WAx::WAxHTTPLibs::Mechanize.new {|a|  a.log = Logger.new(file)}    
              
          else
            agent = WAx::WAxHTTPLibs::Mechanize.new {|a| a.log = Logger.new(false)}
          end 
        end
        
       req_sequence(opts, agent)
       
      end
      
      
   
      
    #
    # Determines method and process based off this information   
    #
    def req_sequence(opts, agent)         
          # Request object cleared/init'd
          req = nil
          
          # Response Code Error object cleared/init'd
          self.rce = nil
                
          # This section is for massing the URL related data together.
          url  = opts['RURL'] 
         
          # rparams
          rparams = opts['RPARAMS'] || []
          
          # User Agent Information
          ua = opts['UA']
          agent.user_agent = ua || 'Mechanize'  
        
          # Proxy options (if any)
          proxyaddr = opts['PROXY_ADDR'] || ''
          proxyport = opts['PROXY_PORT'] || ''   
          
         #Begin setting a proxy if need be  
          if (proxyport != '') and (proxyaddr != '') and (proxyport != nil) and (proxyaddr !=nil)
          agent.set_proxy("#{proxyaddr}", "#{proxyport}") 
          end 
                      
          # This is the HTTP Method chosen by the dev, set to lowercase
          req_type = opts['method'].downcase
            
          # Headers for the request
          headers = opts['HEADERS'] || {}
            
          # rfile = file to put on remote server 'PUT" method specific
          rfile = opts['RFILE'] || ''
            
          # rfile_content = content within the file
          rfile_content = opts['RFILECONTENT'] || ''     
           
           redirect_bool = opts['REDIRECT'] 
            
            if (is_false?(redirect_bool))
              agent.redirect_ok = false
            else
              agent.redirect_ok = true
            end
             
          # This allows us to set a CA file if need be
          ca_file = opts['CAFILE'] || nil
          if (ca_file)
              agent.ca_file = ca_file
          end
          
          # Keep Alive Settings
          keep_alive = opts['KEEP-ALIVE'] || nil
          if (keep_alive)
            agent.keep_alive = keep_alive              
          end
          
          # Basic Authorization Settings
          basic_auth_user = opts['BASIC_AUTH_USER'] || nil
          basic_auth_pass = opts['BASIC_AUTH_PASS'] || nil     
          if (basic_auth_user) and (basic_auth_pass) 
            agent.basic_auth("#{basic_auth_user}", "#{basic_auth_pass}")
          end
            
          # Makes a decision based on the supplied HTTP Method.
          abbr = 'agent_'+ "#{req_type}"
          if self.respond_to?(abbr)
            self.send(abbr, agent, url, rparams, headers, rfile, rfile_content)
          end
          
          
          rescue WAx::WAxHTTPLibs::Mechanize::ResponseCodeError => self.rce
                 
          rescue => $!
                       
          prnt_err("Mechanize Error: #{$!}")
        
        end
    
        
    #
    # Check to see if the user or developer has set a redirect option to false
    #
    def is_false?(string)
     string == "false"
    end                
    
    #
    # Method to return a the request/resp debug info.
    # Most often used within modules to create dradis logs.
    #
    def req_seq
      file = "#{LogsDir}agent.log"
      str = ''
      if File.exists?(file)
       File.readlines(file).each do |line|
         str << "#{line}"
       end
      end     
      return str
    end
    
    #
    # HTTP GET
    #            
    def agent_get(agent, url, rparams, headers, rfile, rfile_content)
       agent.get("#{url}", rparams)
    end    
    
                
    #
    # HTTP POST
    #
    def agent_post(agent, url, rparams, headers, rfile, rfile_content)
      agent.post("#{url}", rparams, headers)
    end  
     
     
    #
    # HTTP PUT
    #
    def agent_put(agent, url, rparams, headers, rfile, rfile_content)
      agent.put("#{url}#{rfile}", "#{rfile_content}", :headers => headers )
    end
    
    
    #
    # HTTP DELETE
    #
    def agent_delete(agent, url, rparams, headers, rfile, rfile_content)
      agent.delete(url, rparams, headers)
    end
    
    
    #
    # HTTP HEAD
    #
    def agent_head(agent, url, rparams, headers, rfile, rfile_content)
      agent.head(url, rparams, headers)
    end
    
    
    # Shim, makes conversion as painless as possible (we hope)
    
    alias send_request_cgi mech_req
    

end end end end