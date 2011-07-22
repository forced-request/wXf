class WebXploit < WXf::WXfmod_Factory::Buby 

  module Runner
  include WXf::WXfassists::Buby::BubyApi
    
    # The real work of parsing the page and collecting words.
    def parse_body(obj)
      
      doc = Nokogiri::HTML(obj.response_str)
      # xpath for a few items.
      doc.xpath("//*[name()='h1' or name()='h2' or name()='h3' or name()='h4' or name()='h5' or name()='title' or name()='p' or name()='span']").each do |node|
        # Lose response headers that might get in.
        if node.text.match(/HTTP\/1.1/i) == nil
          prettynode = node.text.split(/\s+/)
          prettynode.each do |nice|
            # Lose punctuation.
            nice = nice.gsub(/[,\.:;\(){}\[\]"]/,'')
            if nice.length >= $datahash['WORDLEN'] && nice.length <= 20
              nice = nice.strip
              @mywords << nice
            end
          end
        end
      end
    end
  
    def release_the_kraken    
      sortedwords = @mywords.sort.uniq
      
      sortedwords.each do |wordy|
        prnt_plus(wordy)
      end
      
      filename = $datahash['LFILE']
      File.open(filename, "w+") do |lines|
        lines.puts sortedwords
      end
      
    end
  
    def get_responses
      @mywords = []
      proxy_hist = get_proxy_history
      if proxy_hist.length > 0
      proxy_hist.each_with_index do |obj, idx|
        cnt = idx
        # If this is a response
        if obj.request != true
        if obj.response_headers.to_s.match(/Content-Typetext\/html/i)
          parse_body(obj)
        end
        end
      end     
      end
    end
  
  
  end
    


    def initialize
      super(

          'Name' => 'Create Wordlist from Proxy History',
          'Description' => %q{
          Parses proxy history reponses into a wordlist similar to Robin Wood's CeWL.
          Best part is since we're working with previously visited pages no spidering
          is necessary and we minimize trips to the server.
           },
          'Version' => '1.0',
          'References' =>
           [
             ['http://blog.portswigger.net/2009/04/using-burp-extender.html']
           ],
          'Author' => ['Saint Patrick <saintpatrick@l1pht.com>',],
          'License' => WXF_LICENSE
      
      )
      
      init_opts([
        OptString.new('LFILE', [true, "Enter the local file to save to", "#{ModWordLists}gen_wordlist.txt"]),
        OptInteger.new('WORDLEN', [false, "Minimum word length", 5]),
      ])
    end
    
    def run
      $datahash = datahash
      if $burp
       $burp.extend(Runner)
       $burp.get_responses()
       prnt_plus("Extending the module, please wait...")
       $burp.release_the_kraken()
       select(nil,nil,nil, 3)
       prnt_gen("Running module...")
      else
       prnt_err("A burp instance is not running")
      end
      rescue => $!
        prnt_err("#{$!}")
    end


end