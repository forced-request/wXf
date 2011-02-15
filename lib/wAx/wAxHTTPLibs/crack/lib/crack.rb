module WAx
module WAxHTTPLibs
module Crack
  VERSION = "0.1.8".freeze
  class ParseError < StandardError; end
end end end

require 'wAx/wAxHTTPLibs/crack/lib/crack/core_extensions'
require 'wAx/wAxHTTPLibs/crack/lib/crack/json'
require 'wAx/wAxHTTPLibs/crack/lib/crack/xml'