#!/usr/bin/env ruby
# 
# Created Oct 20 2011
#

class WebXploit < WXf::WXfmod_Factory::Auxiliary

 include WXf::WXfassists::General::MechReq
 # Hash to store array of page contents
 $page_contents = Hash.new
  def initialize
      super(
        'Name'        => 'Site Map Enumerator',
        'Version'     => '1.1',
        'Description' => %q{
          Recursively enumerate a site map for any given domain },
        'Author'      => ['John Poulin' ],
        'License'     => WXF_LICENSE
        )
   
      init_opts([
		OptString.new('RURL', [true, " ", "http://example.com"]),
		OptString.new('VERBOSE', [true, " ", "false"]),
		OptString.new('STARTPAGE', [true, "Page of which to start enumeration", "index.php"]),
		OptString.new('MAX_DEPTH', [true, "Maximum depth of recursion", "3"]),	
      ])
  
  end
  
  def run
	# Parse url info from RURL
	@url_info = splitRURL(datahash['RURL'].to_s)
	@domain = @url_info[2]
	@protocol = @url_info[1]
	
	# If unable to parse URL, quit
	if @url_info == -1
		return 1
	end
	
	verbose = datahash['VERBOSE']

	# Hash to store tested results
	# Hash: [pagename => status]
	@pageList = Hash[(datahash['RURL'] + "/" +  datahash['STARTPAGE']) => ""]
	
	# Search for links in robots.txt file
	parseRobots(datahash['RURL'])

	# Visit start page
	visitPage(datahash['RURL'] + "/" +  datahash['STARTPAGE'], 0)

	# Spidering is done - Output results
	@pageList.each { | page, status |
			print_good(page)	
	}

	puts "Total Results: #{@pageList.length}"
  end


	# Visit a page and scan contents
	# Page should always be in the form of http(s)://domain.tld/directory/filename.ext
	def visitPage(page, currDepth)
		# Parse Directory
		currDir = parseDirectory(page)
	
		# Return if we've reached the maximum depth
		if currDepth >= datahash['MAX_DEPTH'].to_i
			return
		end


		# Ignore: .pdf, .jpg, .jpeg, .png, .gif, .bmp, .zip, .tar.gz, .exe
		# We don't really want to download these files...
		bad_exts = Array[".pdf", ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".zip", ".tar", ".exe", ".mov", ".mp4", ".mp3",
		".wav"]

		# skip pages with bad file extensions
		bad_exts.each { |ext| 
			if page.include? ext
				return
			end
		}

		# If this page has already been visited, break
		if @pageList[page] != ""
			return
		end

		# Don't scan pages outside of domain
		if !page.include? @domain.to_s
			return
		end

		if datahash['VERBOSE'] == "true"
			prnt_gen("Visiting page: #{page}")
		end

		# Create request for page
		res = mech_req({
			'method' => "GET",
			'UA' => datahash['UA'],
			'RURL' => page,
		})

		# If request is valid, scan page
		if res and res.respond_to?('code') and res.code == "200"
			$page_contents[page]=res.body
			@pageList[page] = "200"
			scanFile(res.body, currDepth, currDir)
		else
			if !res.respond_to?('code')
				code = res
			else
				code = res.code
			end

			# Update HTTP Code in hash
			@pageList[page] = code
	
	
			if datahash['VERBOSE'] == true
				print_error("[#{code}] Unable to view file contents: #{page}")
			end

			return -1
		end
	end

	# @param contents 	-> File contents to be scanned
	# @param depth		-> Current depth of recursion
	# @param dir		-> Current directory
	def scanFile(contents, depth, dir)
		href_elements = contents.scan(/href="(.*?)"/m)	
	
		# Iterate over each href element found
		href_elements.each { |item|
			# Ignore anchor elements. E.g., <a href="#anchor">
			if item.to_s.match(/#(.*?)/m)
				next
			end

			# Ignore mailto elements
			# Todo: Capture Mailto elements
			if	item.to_s.match(/mailto/m)
				next	
			end

			# Hack until solution is found
			# Ignore ../file.ext issues
			#if item.to_s.match(/\.\.\/[a-zA-Z0-9\-\_\.]*/)
			#	next
			# end
		
			# Add page value to hash if it's not nil
			linkVal = parseLink(item.to_s, dir)

			# Skip nil items
			# Nil items are items that either couldn't be parsed, or are restricted files
			if linkVal.nil?
				next
			end
			
			addValue(linkVal)
	
			# If we haven't visited the page, do so
			if (@pageList.has_key? linkVal and @pageList[linkVal] == "") or !@pageList.has_key? linkVal

				# Recurse to page
				visitPage(linkVal.to_s, depth + 1)
				
				# Display page found
				if datahash['VERBOSE'] == "true" 
					#print_good("Found page: #{item.to_s}")
				end
			end
		}

	end
	
	# @param contents		-> The page to format
	# @param dir			-> Our current directory
	# @description 			-> Returns formatted url
	def parseLink(contents, dir)
		link = contents
		
		# Ignore pages outside of the domain
		
		if link.include? @domain
			# Return parsed page name
			return link
		else
			# will be nil or -1
			dom = parseDomain(link)


			# If no directory was specified, leave as current directory
			# Looks like there might be a problem here
			if dir.to_s != "-1"
				link = dir + "/" + link
				if dir[0,1] != "/"
					link = "/" + link
				end
			else
				link = "/" + link
			end


			while link.include? "../"

			# Parse out ../ and ./
				link.gsub!(/[a-zA-Z0-9\_\-]+\/\.\.\//, "")
			end

			# If domain isn't specified, assume it's the same
			if dom == -1
				return @protocol + "://" + @domain  + link
			end

			# Check whether link contains domain
			# If so, ignore it.
			# Otherwise, 
			return nil
		end
		
		#return link
	end

	# Split RURL for records
	# Return hash of  0 => url, 1 => protocol, 2 => domain, 3 => directories, 4 => file
	def splitRURL(url)
		val = url.match(/(http|https):\/\/([a-zA-Z0-9\-\_\.]*)(\/[a-zA-Z0-9\.\/]*)?/)
	
		# Not able to split -> die
		if val == nil
			return -1
		end

		return val

	end

	# Parse domain from given url
	def parseDomain(url)
		dom = url.match(/(http|https):\/\/([a-zA-Z0-9\.]*)(\/[a-zA-Z0-9\.\/]*)?/)

		if dom == nil
			return -1
		else
			return dom[2]
		end
	end

	# Parse directory from given URL
	def	parseDirectory(url)
		dir = url.match(/(http|https):\/\/([a-zA-Z0-9\.]*)(\/[a-zA-Z0-9\-\_\/]*)(\/[a-zA-Z0-9\.]*)/)

		if dir == nil
			return -1
		else
			return dir[3]
		end
	end

	# Add value to hash
	def addValue(val)
		if !@pageList.has_key? val.to_s
			@pageList[val] = ""
		end
	end

	# Parse robots file
	# Add file / directory entries to @pageList for iteration
	def parseRobots(url)
		prnt_gen("Parsing robots.txt file")
		
		# Create request for page
		res = mech_req({
			'method' => "GET",
			'UA' => datahash['UA'],
			'RURL' => url + "/robots.txt"
		})
		
		# Response Fouund
		if res and res.respond_to?('code') and res.code == "200"
			# Iterate over each line
			lines = res.body.split(/\r?\n/)
			lines.each { |line|
				parts = line.match(/(Disallow|Allow)\: (.*)/)
				if parts != nil
					if parts[2][0].chr == "/"
						tmp_val = url + parts[2]
					else
						tmp_val = url + "/" + parts[2]
					end
					@pageList[tmp_val] = ""
				end
			}
		else
			prnt_err("robots.txt file not found")
			return false
		end
	end
  
end
