require 'wAx/wAxHTTPLibs/mechanize/lib/mechanize/chain/handler'
require 'wAx/wAxHTTPLibs/mechanize/lib/mechanize/chain/uri_resolver'
require 'wAx/wAxHTTPLibs/mechanize/lib/mechanize/chain/parameter_resolver'
require 'wAx/wAxHTTPLibs/mechanize/lib/mechanize/chain/request_resolver'
require 'wAx/wAxHTTPLibs/mechanize/lib/mechanize/chain/custom_headers'
require 'wAx/wAxHTTPLibs/mechanize/lib/mechanize/chain/connection_resolver'
require 'wAx/wAxHTTPLibs/mechanize/lib/mechanize/chain/ssl_resolver'
require 'wAx/wAxHTTPLibs/mechanize/lib/mechanize/chain/pre_connect_hook'
require 'wAx/wAxHTTPLibs/mechanize/lib/mechanize/chain/auth_headers'
require 'wAx/wAxHTTPLibs/mechanize/lib/mechanize/chain/header_resolver'
require 'wAx/wAxHTTPLibs/mechanize/lib/mechanize/chain/response_body_parser'
require 'wAx/wAxHTTPLibs/mechanize/lib/mechanize/chain/response_header_handler'
require 'wAx/wAxHTTPLibs/mechanize/lib/mechanize/chain/response_reader'
require 'wAx/wAxHTTPLibs/mechanize/lib/mechanize/chain/body_decoding_handler'

module WAx
module WAxHTTPLibs

class Mechanize
  class Chain
    def initialize(list)
      @list = list
      @list.each { |l| l.chain = self }
    end

    def handle(request)
      @list.first.handle(self, request)
    end

    def pass(obj, request)
      next_link = @list[@list.index(obj) + 1]
      next_link.handle(self, request) if next_link
    end
  end
end

end end