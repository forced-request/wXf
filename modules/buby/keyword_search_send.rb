

class WebXploit < WXf::WXfmod_Factory::Buby  
   
  
  module Runner   
    
    attr_accessor :fuzz_params 
    
    #
    #
    #  
    def fuzz_add
      self.fuzz_params = []
      fuzzfile = $datahash['LFILE']     
      if fuzzfile and File.exist?(fuzzfile)
        check = File.open(fuzzfile)
        check.each do |fuzzp|
          self.fuzz_params << fuzzp.chomp
        end   
      end
    end
    
    #
    # Request Method extraction (Looking for GET or POST)
    #
    def req_meth(obj)
      http_meth = ''
      if obj.respond_to?('request_headers')
        http_meth = obj.request_headers[0].to_s[0..3]
      end
      return http_meth
    end
    
    
  #
  # Lets extract any strings that match
  # ...our manual fuzz array
  #
  def extract_str(*objs)
    http_meth, req, count = objs
    bparam = {}
    if http_meth == 'POST'   
      bparam_split_amp = req.request_body.split('&')
      bparam_split_amp.to_s.split('=')
      bparam_split_amp.each do |itm|
        spl = itm.split('=')
        bparam["#{spl[0]}"] = "#{spl[1]}"
      end
    elsif http_meth == 'GET '
      path = req.url.to_s.match(/^.*?:\/\/.*?(\/.*)$/)
      rpath = "#{path[1]}".match(/^[^?#]+\?([^#]+)/)
      if not rpath.nil?
        bparam_split_amp = "#{rpath[1]}".split('&')
        bparam_split_amp.to_s.split('=')
        bparam_split_amp.each do |itm|
          spl = itm.split('=')
          bparam["#{spl[0]}"] = "#{spl[1]}"
        end
      end
    end
   
   proto = req.protocol == 'https' ? true : false
   
   bparam.each do |fuzzp,value|
     if self.fuzz_params.include?(fuzzp) and isInScope($datahash['RURL']) == true
       sendToIntruder(req.host, req.port, proto, req.request_string)
       sendToRepeater(req.host, req.port, proto, req.request_string, "#{fuzzp}-#{count}")
       issueAlert("We've sent #{fuzzp}-#{count} to intruder")
       issueAlert("We've sent #{fuzzp}-#{count} to repeater")
     end
   end
end
    
    
    #
    # Runs this whole shebangabang
    #
    def go_and_search
      proxy_hist = get_proxy_history      
      if proxy_hist.length > 0
        proxy_hist.each_with_index do |obj, idx|
          cnt = idx
          if obj.request
            hmeth = req_meth(obj)
            extract_str(hmeth, obj, cnt)
          end
        end     
      end
    end
    
 end 
    
  
  def initialize
    super(

            'Name'        => 'Keyword Search and Send',
            'Description' => %q{
             Searches Burp's proxy history looking for parameters that meet keyword searches (keywords are listed in the LFILE).
             When found, sends to repeater and intruder and then alerts the user of the activity. 
            },
            'References'  =>
             [               
             ],
            'Author'      => [ 'CKTRICKY',],
            'License'     => WXF_LICENSE
  
    )
    
    init_opts([
      OptString.new('RURL', [true, "Enter the remote url value", "http://www.example.com"]),
      OptString.new('LFILE', [true, 'Directory Traversal Strings File','wordlists/buby/keywords.txt']),           
    ])
  end

  
  def run
   $datahash = datahash 
   if $burp
     $burp.extend(Runner)
     $burp.fuzz_add
     prnt_plus("Extending the module, please wait...")
     select(nil,nil,nil, 3)
     prnt_gen("Running module...")
     $burp.go_and_search
   else
     prnt_err("A burp instance is not running")
   end
  rescue => $!
    puts "#{$!}"
  end
  
end
