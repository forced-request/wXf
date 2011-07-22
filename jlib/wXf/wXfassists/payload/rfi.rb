require 'wXf/wXfui'

module WXf
module WXfassists
module Payload
  module RFI
  
    
    
       #
       # We need to initiate a webserver instance
       #
       def webserver_start_lhtml(opts, control)
        begin
           svr = WXf::WXfwebserver::WebServer.new(opts,control)
           control.add_web_activity(svr)
           servlet = WXf::WXfwebserver::Configurable
           svr.add_servlet(opts['LPATH'], servlet,opts)
           svr.start
           rescue
            print "[wXf] Error when starting the webserver: #{$!}\n"
         end      
       end
       

       #
       # We need to initiate a webserver instance
       #
       def webserver_start_lfile(opts, control)
        begin
           svr = WXf::WXfwebserver::WebServer.new(opts,control)
           control.add_web_activity(svr)
           svr.add_file(opts)
           svr.start
           rescue
            print "[wXf] Error when starting the webserver: #{$!}\n"
         end      
        end
    
       
        
       #
       # Instead of a user firing up a webserver instance, then using the exploit,
       # ...we'd prefer to just fire it up for them. 
       #
       def webserver_init_lhtml(input, lurl)  
        if control.webstack.empty?   
         prnt_gen("Would you like us to start a listener? (y/n)\n")
         STDOUT.flush
         answer = gets.chomp.downcase
        
         if answer == 'y'          
          opts = default_opts(lurl)
         
          opts['LHTML'] = input || ''
         
           if (control)
            #Extract key-value pairs from default_opts
            lport = opts['LPORT']
         
            # Remove a colon if it exists  
            lport.to_s.gsub!(':', '')
          
            control.prnt_plus("Starting listener...")
            webserver_start_lhtml(opts, control)            
            sleep 5.0
           end
         else
           return
         end
        end
       end   
       
       #
       # Instead of a user firing up a webserver instance, then using the exploit,
       # ...we'd prefer to just fire it up for them. 
       #
       def webserver_init_lfile(input, lurl)
        if control.webstack.empty?            
         prnt_gen("Would you like us to start a listener? (y/n)\n")
         STDOUT.flush
         answer = gets.chomp.downcase
         if answer == 'y'
          opts = default_opts(lurl)
            
          opts['LFILE'] = input || ''
            
          if (control)
            #Extract key-value pairs from default_opts
            lport = opts['LPORT']
            
            # Remove a colon if it exists  
            lport.to_s.gsub!(':', '')
            
            control.prnt_plus("Starting listener...")
            webserver_start_lfile(opts, control)
            sleep 5.0
          else 
            return
          end   
         end
        end
       end  
           
       
       #
       # Method which performs a check to see if the user simply chose default options
       # or entered something new.
       #    
       def default?(input)
         if input == '' 
           return true
         else
           return false
         end
       end
       
       
       #
       # This checks to see if we have some default LURL options that we can employ when starting a webserver
       #
       def default_opts(lurl)
         opts = {}
            
              if (lurl)
                # Regex operations to extract address, port and prefix           
                prefix = lurl.match(/(http:\/\/|https:\/\/)/)
                plurl = lurl.gsub("#{prefix}", '')           
                lhost = plurl.match(/\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/)
                lport = plurl.match(/:+\d{1,5}/)
                
                # Assign the key, value pairs in opts 
                if (prefix)
                  opts['PREFIX'] = prefix.to_s
                else
                  opts['PREFIX'] = 'http://'
                end
                
                if (lhost)
                  opts['LHOST'] = lhost.to_s
                else
                  opts['LHOST'] = '127.0.0.1'
                end
                
                if (lport)
                  opts['LPORT'] = lport.to_s
                else
                  opts['LPORT'] = '8888'
                end                
              end
            
         # Return this hash when the default_opts method is called    
         return opts
       end 
  
  
  
  
  end

end end end