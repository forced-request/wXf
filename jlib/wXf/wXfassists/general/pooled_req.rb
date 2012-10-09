require 'wXf/wXfui'

begin
  require 'rubygems'
  require 'mechanize'
  require 'celluloid'
rescue LoadError
end

module WXf
module WXfassists
module General
module PooledReq

class Pool
	include Celluloid
	include WXf::WXfassists::General::MechReq
	require 'net/http'

	##
	# Initialize Pool Object w/ thread count
	#
	def initialize
		# Automatic restarting of Celluloid might cause issues
		# Should probably see if this variable exists
		@queue = []
		#@a = Mechanize.new
	end

	##
	# Send threaded HTTP Requests
	#	@action: Proc (request object)
	#	@params: Hash (request params)
	#	@response_action: Proc (action to be performed as response)
	#	@args:		List of other arguments
	#
	def get(url)
		#a = Mechanize.new
		#return a.get(url)
		response = Net::HTTP.get URI(url)
		return response
	#def get(action,params, *args)
	#def get(action, params, response_action, *args)
		#res = action.call(params)
		#response_action.call(res, params, args)
		#return res
		#rescue Exception => e
		#	return "Exception: #{e}"
	end


# The following code is currently in development.
# This will serve to further abstract the current threading.
=begin

	##
	# Add Request to queue
	#
	# request: Proc.
	def add(opts)
		# Add Request to queue
		@queue << {:id => @queue.length, :options => opts, :response => nil}
	end

	##
	# Execute the request
	#
	def req(action, opts)
		puts "Sending Request"
		
		puts opts
		res = action.call(opts[:options])
		#puts res
	end

	##
	# Begin executing requests
	#
	def execute
		@queue.each { |v|
			self.future.req(Proc.new { |o| mech_req(o)}, v)
		}	
	end
=end
end
end end end end
