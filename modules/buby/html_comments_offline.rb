

class WebXploit < WXf::WXfmod_Factory::Buby 
    
  module Runner
    
    
    #
    # Extract html comments from response body
    #
    def extract_html_comments(msg)            
      prefix = msg.protocol == "https" ? "https://" : "http://"
      url = "#{prefix}#{msg.host}" 
        if url == $datahash['RURL']
          comment = msg.response_body.match(/<!--\n{0,}.+?\n{0,}-->/)
          if !comment.nil?
            file = "#{WXf::LogsDir}offline_comments_#{msg.host}"
            File.open(file, "a") {|f| f.write("HTML COMMENT IN: #{msg.url}\r\n==========================\n#{comment}\n\n")}
            $burp.alert("Placed comment in #{file}")
          end
        end
    end
    
    #
    # Runs this whole shebangabang
    #
    def go_and_search
      proxy_hist = get_proxy_history
      if proxy_hist.length > 0
        proxy_hist.each do |obj|
          if obj.response
            extract_html_comments(obj)
          end
        end
      end
    end
   
  end
    
  
  def initialize
    super(

            'Name'        => 'Extract HTML Comments',
            'Description' => %q{
             Puts the remote URL (RURL) in scope and extracts comments from any in scope site.
            },
            'Version' => '1.0',
            'References'  =>
             [       
               ['http://blog.portswigger.net/2009/04/using-burp-extender.html']        
             ],
            'Author'      => [ 'CKTRICKY',],
            'License'     => WXF_LICENSE
  
    )
    
    init_opts([
      OptString.new('RURL', [true, "Enter the remote url value", "http://www.example.com"])           
    ])
  end

  
  def run 
   $datahash = datahash
   if $burp
     $burp.extend(Runner)
     prnt_plus("Extending the module, please wait...")
     select(nil,nil,nil, 3)     
     prnt_gen("Running module...")
     $burp.go_and_search
   else
     prnt_err("A burp instance is not running")
   end
  rescue => $!
    prnt_err("#{$!}")
  end
  
end
