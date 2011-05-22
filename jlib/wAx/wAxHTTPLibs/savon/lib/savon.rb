module WAx
module WAxHTTPLibs
module Savon

  # Raised in case of an HTTP error.
  class HTTPError < StandardError; end

  # Raised in case of a SOAP fault.
  class SOAPFault < StandardError; end

end end end

# standard libs
require "logger"
require "net/https"
require "base64"
require "digest/sha1"
require "rexml/document"
require "stringio"
require "zlib"
require "cgi"

# gem dependencies
require "wAx/wAxHTTPLibs/builder/lib/builder"
require "wAx/wAxHTTPLibs/crack/lib/crack/xml"

# core files
require "wAx/wAxHTTPLibs/savon/lib/savon/core_ext"
require "wAx/wAxHTTPLibs/savon/lib/savon/wsse"
require "wAx/wAxHTTPLibs/savon/lib/savon/soap"
require "wAx/wAxHTTPLibs/savon/lib/savon/logger"
require "wAx/wAxHTTPLibs/savon/lib/savon/request"
require "wAx/wAxHTTPLibs/savon/lib/savon/response"
require "wAx/wAxHTTPLibs/savon/lib/savon/wsdl_stream"
require "wAx/wAxHTTPLibs/savon/lib/savon/wsdl"
require "wAx/wAxHTTPLibs/savon/lib/savon/client"
require "wAx/wAxHTTPLibs/savon/lib/savon/version"

