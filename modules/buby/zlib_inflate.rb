require 'zlib'

class WebXploit < WXf::WXfmod_Factory::Buby 
    
  module Runner
    
    include WXf::WXfui::Console::Prints::PrintSymbols
    
      def evt_proxy_message(*param)
        msg_ref, is_req, rhost, rport, is_https, http_meth, url, resourceType, status, req_content_type, message, action = param
        str_msg = message.dup
          if is_req == true  and rhost == $datahash['RHOST']
            split_msg = str_msg.split(' ')
            true_index = nil  
              split_msg.each_with_index do |item, idx|
                if item.match(/Content-Length:/)
                  true_index = idx + 1
                end
              end
            if !true_index.nil? and true_index != 0 
              begin
                eval("split_msg.slice!(0..#{true_index})")
                zlib_str = split_msg.to_s
                zstream = Zlib::Inflate.new
                inf = zstream.inflate("#{zlib_str}")
                zstream.finish
                zstream.close
                message.gsub!("#{zlib_str}", "#{inf}")
              rescue => $!
                  prnt_err("We've received the following error: #{$!}")
              end
            end
          end
         return super(*param)
      end    
  end 
    
  
  def initialize
    super(

            'Name'        => 'ZLib Inflate',
            'Description' => %q{
             Inflates ZLib compressed data (a.k.a decompresses) and then sends to Burp.
            },
            'References'  =>
             [               
             ],
            'Author'      => [ 'CKTRICKY',],
            'License'     => WXF_LICENSE
  
    )
    
    init_opts([
      OptString.new('RHOST', [true, "Enter the remote host value", "www.example.com"])             
    ])
  end

  
  def run
   $datahash = datahash 
   if $burp
     $burp.extend(Runner)
     prnt_gen("We've started running the modules")
   else
     prnt_err("A burp instance is not running")
   end
  rescue => $!
    puts "#{$!}"
  end
  
end
