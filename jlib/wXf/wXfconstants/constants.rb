module WXf

  
  
  #
  # Version information
  #
  Major = 1
  Minor = 0
  Platform = "EXPERIMENTAL JRUBY VERSION"
  Version = "#{Major}.#{Minor} - #{Platform}"
  
  
  #
  # Generic way of creating module types, used often when making decisions based off of <module>.type
  #
  BUBY = 'buby'
  BURP = 'burp'
  EXP = 'exploit'
  PAY = 'payload'
  WEBSERVER = 'webserver'
  AUXILIARY = 'auxiliary'
  
  FUNCTION_TYPES = 
  [ 
    BUBY,
    BURP, 
    EXP,
    PAY,
    WEBSERVER,
    AUXILIARY
    ]
 
  WXF_LICENSE = 'Web Exploitation Framework License GPL'
  
  # Need to put good ones in here eventually, these lame ones are for testing.
  POPULAR_URLS = 
  [
    "http://",
    "https://",  
    "http://www.yahoo.com",
    "http://www.cnn.com",
    "http://www.foxnews.com",
    "http://www.newegg.com"    
  ]    
  
  LINUX_COMMANDS =
  [
    "ls",
    "clear",
    "ifconfig",
    "dir",
    "cat",
    "nano",
    "cd" 
    ]
    
        
  #
  # Path shortcuts
  #      
  WorkingDir = File.expand_path(File.join(File.dirname(__FILE__), '..', '..','..'))
  ModWorkingDir = File.expand_path(File.join(File.dirname(__FILE__), '..', '..','..')) + File::SEPARATOR + 'modules'
  ModWordLists =  File.expand_path(File.join(File.dirname(__FILE__), '..','..','..')) + File::SEPARATOR + 'datum/wordlists/'
  ModDatum =  File.expand_path(File.join(File.dirname(__FILE__), '..','..','..')) + File::SEPARATOR + 'datum/'
  ModRurls =  File.expand_path(File.join(File.dirname(__FILE__), '..','..','..')) + File::SEPARATOR + 'rurls/'  
  PayloadsDir = File.expand_path(File.join(File.dirname(__FILE__), '..','..','..')) + File::SEPARATOR + 'datum/payloads/'
  LogsDir = File.expand_path(File.join(File.dirname(__FILE__), '..','..','..')) + File::SEPARATOR + 'datum/logs/' 

  # User agents
   UA_MAP = {
       
          '1' => 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)',
          '2' => 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 1.1.4322; .NET CLR 2.0.50727)',
          '3' => 'Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.4b) Gecko/20030516 Mozilla Firebird/0.6',
          '4' => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_2; de-at) AppleWebKit/531.21.8 (KHTML, like Gecko) Version/4.0.4 Safari/531.21.10',
          '5' => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2) Gecko/20100115 Firefox/3.6',
          '6' => 'Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.4a) Gecko/20030401',
          '7' => 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.4) Gecko/20030624',
          '8' => 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.1) Gecko/20100122 firefox/3.6.1',
          '9' => 'Mozilla/5.0 (compatible; Konqueror/3; Linux)',
          '10' => 'Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1C28 Safari/419.3',
          '11' => "WWW-Mechanize/#{Version} (http://rubyforge.org/projects/mechanize/)"
     }
 
   #Content types  
   CONTENT_TYPES = {
      '1'  => 'application/x-www-form-urlencoded',
      '2'  => 'application/EDI-X12',
      '3'  => 'application/EDIFACT',
      '4'  => 'application/javascript',
      '5'  => 'application/octet-stream',
      '6'  => 'application/ogg',
      '7'  => 'application/pdf',
      '8'  => 'application/xhtml+xml',
      '9'  => 'application/xml-dtd',
      '10' => 'application/json',
      '11' =>'application/zip',
      '12' => 'audio/basic',
      '13' => 'audio/mp4',
      '14' => 'audio/mpeg',
      '15' => 'audio/ogg',
      '16' => 'audio/vorbis',
      '17' => 'audio/x-ms-wma',
      '18' => 'audio/vnd.rn-realaudio',
      '19' => 'audio/vnd.wave',
      '20' => 'image/gif',
      '21' => 'image/jpeg',
      '22' => 'image/png',
      '23' => 'image/svg+xml',
      '24' => 'image/tiff',
      '25' => 'image/vnd.microsoft.icon',
      '26' => 'message/http', 
      '27' => 'multipart/mixed',
      '28' => 'multipart/alternative',
      '29' => 'multipart/related',
      '30' => 'multipart/form-data',
      '31' => 'multipart/signed',
      '32' => 'multipart/encrypted',
      '33' => 'text/css',
      '34' => 'text/csv',
      '35' => 'text/html',
      '36' => 'text/javascript',
      '37' => 'application/javascript',
      '38' => 'text/plain',
      '39' => 'text/xml'
     
       
     }
  
 
end
