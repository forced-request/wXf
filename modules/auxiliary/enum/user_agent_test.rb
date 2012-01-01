

class WebXploit < WXf::WXfmod_Factory::Auxiliary

   include WXf::WXfassists::General::MechReq 
   
  
  
  def initialize
    super(

            'Name'        => 'User Agent Tester',
            'Version'     => '1.1',
            'Description' => %q{
             This is a port of ChrisJohnRiley's UAtester.  First we send three requests to ensure we are getting the
             same results back each time.  Assuming we do, we iterate through our list of User-Agent strings and print
	     any HTTP Response Headers that have changed.
                                },
            'References'  =>
             [
                [ 'URL', 'http://code.google.com/p/ua-tester/' ],
		            [ 'BLOG', 'http://blog.c22.cc' ],
             ],
            'Author'      => [ 'CG', 'mubix', 'ChrisJohnRiley' ],
            'License'     => WXF_LICENSE
    
    )
    
      
      init_opts([
          OptBool.new('BASELINE', [true, 'Enables baseline checks for same Content-Length for same User-Agent requests', true]),
         ])
  end

  
  
def run
  
   
    uastrings = [
    # Default Browsers
    "", #blank
    "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)",
    "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0)",
    "Mozilla/5.0 (Windows; U; MSIE 7.0; Windows NT 6.0; en-US)",
    "Mozilla/5.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727)",
    "Mozilla/4.0 (compatible;MSIE 5.5; Windows 98)",
    "Mozilla/5.0 (Windows; U; Windows NT 6.1; ru; rv:1.9.2.3) Gecko/20100401 Firefox/4.0 (.NET CLR 3.5.30729)",
    "Mozilla/5.0 (Windows NT 6.1; rv:2.0.1) Gecko/20100922 Firefox/4.0.1",
    "Mozilla/5.0 (Windows; U; Windows NT 5.2; rv:1.9.2) Gecko/20100101 Firefox/3.6",
    "Mozilla/5.0 (X11; U; SunOS sun4v; en-US; rv:1.8.1.3) Gecko/20070321 Firefox/2.0.0.3",
    "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/534.7 (KHTML, like Gecko) Chrome/7.0.514.0 Safari/534.7",
    "Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US) AppleWebKit/525.13 (KHTML, like Gecko) Chrome/0.2.149.27 Safari/525.13",
    "Mozilla/5.0 (Windows; U; Windows NT 5.2; en-US) AppleWebKit/533.17.8 (KHTML, like Gecko) Version/5.0.1 Safari/533.17.8",
    "Opera/9.99 (Windows NT 5.1; U; pl) Presto/9.9.9",
    
    #Mobile User Agents
    "Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1A543a Safari/419.3",
    "Mozilla/5.0 (iPad; U; CPU iPhone OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B314 Safari/531.21.10",
    "Mozilla/5.0 (Linux; U; Android 2.1-update1; en-at; HTC Hero Build/ERE27) AppleWebKit/530.17 (KHTML, like Gecko) Version/4.0 Mobile Safari/530.17",
    "jBrowser-WAP",
    "Nokia7650/1.0 Symbian-QP/6.1 Nokia/2.1", 
    
    # Spidering bots (Goolge, MSN, etc..)
    "Googlebot/2.1 (+http://www.google.com/bot.html)",
    "Googlebot-Image/1.0",
    "Mediapartners-Google",
    "Mozilla/2.0 (compatible; Ask Jeeves)",
    "msnbot-Products/1.0 (+http://search.msn.com/msnbot.htm)",
    "mmcrawler",

    # Crazy WTF stuff (TrackBack is the local Apache uastring)
    "Windows-Media-Player/9.00.00.4503",
    "Mozilla/5.0 (PLAYSTATION 3; 2.00)",
    "TrackBack/1.02",
    "wispr",

    # Commonly used tools. Additions from the Mod_Security ruleset
    "Mozilla/4.75 (Nikto/2.01)",
    "curl/7.7.2 (powerpc-apple-darwin6.0) libcurl 7.7.2 (OpenSSL 0.9.6b)",
    "w3af.sourceforge.net",
    "HTTrack",
    "Wget 1.9cvs-stable",
    "Lynx (textmode)",
    ".nasl",
    "paros",
    "webinspect",
    "brutus",
    "java",
      ]
    
    print_status("Sending Baseline Request \n")

    begin
      summary = []
      forwards = []
      contentlength = []
      baselineheaders = []
      contentsame = true
      ua  = "Mozilla/5.0" #our baseline UA
      
      #send three requests and see if we get the same answers (which we should)
      (0..2).each do | baseline |
        res = mech_req({
          'method' => 'GET', 
          'UA'      => ua,
          'RURL'  => rurl,
          'REDIRECT' => 'false', 
        })

      if (res) and (res.header['content-length'].nil?)
        res.header['content-length'] = "#{res.body.bytesize}"
      end    
     
         
      if (res.nil?)
        print_error("No response for #{rurl}")
      elsif (res)
          if (res and res.code == 200)
            print_status("USER AGENT     : #{ua}")
            print_status("URL (ENTERED)  : #{rurl}")
            print_status("RESPONSE CODE  : #{res.code}")
            print_status("CONTENT-LENGTH : #{res.response['content-length']}")
            print_status("CONTENT-LENGTH CALCULATED : #{res.body.size}")
            print_status("HEADERS \n") & res.response.each_pair {|k,v| p "#{k}".upcase + ': ' + v}
            if contentlength.empty? then
              contentlength << res.response['content-length']
            elsif res.response['content-length'] == contentlength.last then
              ''
            else res.response['content-length'] != contentlength.last
              print_error("Received a different content length for same request\n")
              if datahash['BASELINE'] == true
                contentsame = false
                return
              end
            end
          elsif (res and res.code == 302 or res.code == 301)
            print_status("USER AGENT     : #{ua}")
            print_status("URL (ENTERED)  : #{rurl}")
            print_status("URL (RETURNED) : #{res.response['location']}")
            print_status("RESPONSE CODE  : #{res.code}")
            print_status("CONTENT-LENGTH : #{res.response['content-length']}")
            print_status("CONTENT-LENGTH CALCULATED : #{res.body.size}")
            print_status("HEADERS \n") & res.response.each_pair {|k,v| p "#{k}".upcase + ': ' + v}  
            if contentlength.empty? then
              contentlength << res.response['content-length']
            elsif res.response['content-length'] == contentlength.last then
              ''
            else res.response['content-length'] != contentlength.last
              print_error("Received a different content length for same request\n")
              if datahash['BASELINE'] == true
                contentsame = false
                return
              end
            end
          else  (res)
            print_status("USER AGENT     : #{ua}")
            print_status("URL (ENTERED)  : #{rurl}")
            print_status("RESPONSE CODE  : #{res.code}")
            print_status("CONTENT-LENGTH : #{res.response['content-length']}")
            print_status("CONTENT-LENGTH CALCULATED : #{res.body.size}")
            print_status("HEADERS \n") & res.response.each_pair {|k,v| p "#{k}".upcase + ': ' + v}          
            if contentlength.empty? then
              contentlength << res.response['content-length']
            elsif res.response['content-length'] == contentlength.last then
              ''
            else res.response['content-length'] != contentlength.last
              print_error("Received a different content length for same request\n")
              if datahash['BASELINE'] == true
                contentsame = false
                return
              end
            end
          end
      else
        ''
      end

      baselineheaders = res.response
      if baselineheaders['location'] then
        forwards << baselineheaders['location']
      end
    end #Closes begin statement at the top

    if contentsame == false
      print_error("Did not receive the same content-length for same request...exiting")
      return
    elsif
      uastrings.each do | check |
          print_status("Testing User-Agent: #{check}")
          res = mech_req({
            'method' => 'GET',
            'UA' => check,
            'RURL'=> rurl,
            'REDIRECT' => 'false',
           })
            
          if (res.nil?)
            print_error("No response for #{rurl}") 
          elsif (res)
            checkheader = []
            checkheader = res.response
            checkheader.each do | basekey,basevalue|
              if baselineheaders[basekey] != nil then
              	if basekey =~ /^Set-Cookie$/i 	
              		if baselineheaders[basekey] =~ /httponly/i
              		  if basevalue =~ /httponly/i
              			else
              				print_error("ORIGINAL: #{basekey} => [#{baselineheaders[basekey]}]")
              			  print_good("CHANGED:  #{basekey} => [#{basevalue}]")
              			end
              	   elsif baselineheaders[basekey] =~ /secure/i
              		  if basevalue =~ /secure/i
              			else
              			 print_error("ORIGINAL: #{basekey} => [#{baselineheaders[basekey]}]")
              		   print_good("CHANGED:  #{basekey} => [#{basevalue}]")
              		  end
                   end
              	 end
              	 if basekey =~ /expires|vtag|date|time|x-transaction|Set-Cookie|X-Cache|cache-control|Age/i
              	   #Ignore frequently changing headers
              	 elsif basevalue != baselineheaders[basekey] then
                  print_error("ORIGINAL: #{basekey} => [#{baselineheaders[basekey]}]")
                  print_good("CHANGED:  #{basekey} => [#{basevalue}]")
                  end
                else
                  print_good("NEW: #{basekey} => [#{basevalue}]")
                end
                if basekey == "Location" then
                  forwards << basevalue
                end
              end

            baselineheaders.each do | basekey,basevalue|
              if checkheader[basekey] == nil then
                print_error("DELETED: #{basekey} => [#{baselineheaders[basekey]}]")
              end
            end
              
            print_status("RESPONSE CODE  : #{res.code}")
            print_status("CONTENT-LENGTH : #{res.response['content-length']}")
            print_status("CONTENT-LENGTH CALCULATED : #{res.body.size}\n")
            summary << res.code.to_s+"\t\t"+res.response['content-length'].to_s+"\t\t"+check.chomp
          else
            #print_status("You Shouldnt see me but I received a #{res.code}")
            ''
          end
        end
      else
        ''
      end

      print_status("****************************************************************************")
      print_status("*************************** SUMMARY OF RESULTS *****************************")
      print_status("CODE\tCONTENT-LENGTH\tUSER-AGENT")
      summary.each { |x| print_status("#{x}") }
      puts ''
      print_status("**************************** UNIQUE FORWARDS *******************************")
      forwards.uniq.each { |x| print_status("#{x}") }
      puts ''
 
#rescue    

end
end
end
