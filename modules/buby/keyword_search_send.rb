

class WebXploit < WXf::WXfmod_Factory::Buby  
  
  module Runner
    
    include WXf::WXfassists::Buby::BubyApi
  
    attr_accessor :fuzz_params, :found,  :host_hashmap, :request_hashmap   
      
         
      #
      # Grab the fuzz file hoss
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
    # Sort everything out
    #
    def sorter(request_arry)
      prnt_gen("Please choose a request and parameter to send\n")
      request_arry.each do |msg_arry|
        
        index = msg_arry[0]
        msg = msg_arry[1] 
        fuzzp = msg_arry[2]
        proto = msg.protocol == 'https' ? true : false
        
        print("#{index}) #{fuzzp}\n")
      end
      
      param_result = $stdin.gets.chomp
      param_result_int = param_result.to_i
      
      prnt_gen("Choose which function to send to\n")
      print("1) Repeater\n2)Intruder\n")
      
      function_result = $stdin.gets.chomp
      function_result_int = function_result.to_i
      
      request_arry.each do |msg_arry|
        
        index = msg_arry[0]
        msg = msg_arry[1] 
        fuzzp = msg_arry[2]
        proto = msg.protocol == 'https' ? true : false
        
        if index == param_result_int
          case function_result_int
          when 1
            sendToIntruder(msg.host, msg.port, proto, msg.request_string)
            issueAlert("We've sent #{fuzzp} from request #{index} to intruder")
          when 2
            $burp.sendToIntruder(msg.host, msg.port, proto, msg.request_string)
            issueAlert("We've sent #{fuzzp} from request #{index} to repeater")
          end
        end
        
      end
      
    end
      
    
    #
    # Lets extract any strings that match
    # ...our manual fuzz array
    #
    def extract_str(host)
      bparam = []
      $burp.request_hashmap.each do |count, obj|         
        if obj.host == host and obj.request
          http_meth = req_meth(obj)        
          if http_meth == 'POST'   
            bparam_split_amp = req.request_body.split('&')
            bparam_split_amp.to_s.split('=')
            bparam_split_amp.each do |itm|
              spl = itm.split('=')
              if self.fuzz_params.include?("#{spl[0]}") 
                bparam << ([ count, obj, "#{spl[0]}"])
              end 
            end
          elsif http_meth == 'GET '
            path = obj.url.to_s.match(/^.*?:\/\/.*?(\/.*)$/)
            rpath = "#{path[1]}".match(/^[^?#]+\?([^#]+)/)
            if not rpath.nil?
              bparam_split_amp = "#{rpath[1]}".split('&')
              bparam_split_amp.to_s.split('=')
              bparam_split_amp.each do |itm|
                spl = itm.split('=')
                if self.fuzz_params.include?("#{spl[0]}") 
                  bparam << ([ count, obj, "#{spl[0]}"])
                end 
              end
            end
          end
        end 
      end
      
     return if bparam.empty?
     sorter(bparam)
     
  end
        
      #
      # Collect the hosts
      #
      def host_collect
        self.host_hashmap={}
        proxy_hist = get_proxy_history      
        if proxy_hist.length > 0
          proxy_hist.each do |obj|
            if not host_hashmap.value?("#{obj.host}")
              $burp.host_hashmap[host_hashmap.length + 1] = obj.host
            end          
          end     
        end
      end
   
      #
      # Hash the proxy objects
      #
      def hash_proxy_history
        self.request_hashmap={}
        proxy_hist = get_proxy_history      
        if proxy_hist.length > 0
          proxy_hist.each_with_index do |obj, idx|
            cnt = idx + 1
            $burp.request_hashmap[cnt] = obj
          end     
        end
      end
      
  end
    
  
  def initialize
    super(

            'Name'        => 'Keyword Search and Send',
            'Description' => %q{
             Searches Burp's proxy history looking for parameters that meet keyword searches (keywords are listed in the LFILE).
             When found, allows the user to choose to send to repeater or intruder and then alerts the user of the activity. 
            },
            'Version' => '1.0',
            'References'  =>
             [               
             ],
            'Author'      => [ 'CKTRICKY',],
            'License'     => WXF_LICENSE
  
    )
    
    init_opts([
      OptString.new('LFILE', [true, "Keyword list to use","wordlists/buby/keywords.txt"]),           
    ])
  end

  
def run
  if $burp
    $datahash = datahash
    prnt_plus("Extending the module, please wait...\n")
    $burp.extend(Runner)
    $burp.fuzz_add  
    prnt_gen("Running module...\n")
  
    if $burp.host_hashmap.nil? || $burp.host_hashmap.length == 0
      $burp.host_collect
    end
   
    if $burp.request_hashmap.nil? || $burp.request_hashmap.length == 0
      $burp.hash_proxy_history
    end   
   
    if not $burp.request_hashmap.nil?
      if $burp.request_hashmap.length > 0
        message_center
      else
        prnt_err("No proxy history to search")
      end 
    else
      prnt_err("No proxy history to search")
    end
    
  else
    prnt_err("A burp instance is not running")
  end
  rescue => $!
 prnt_err("#{$!}")
  
 end    
    
 def message_center
   if !$burp.host_hashmap.nil? and $burp.request_hashmap.length > 0
     if !$burp.host_hashmap.nil?  and $burp.host_hashmap.length > 0
       prnt_gen("Please choose a host to check\n")
       $burp.host_hashmap.each do |key,value|
         print("#{key}) #{value}\n")         
       end
       result = $stdin.gets.chomp
        
      result_int = result.to_i
   
      if $burp.host_hashmap.has_key?(result_int)
        host = $burp.host_hashmap[result_int]
          $burp.extract_str(host)
      end
     end
   end
 end

end
