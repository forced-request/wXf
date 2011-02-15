module WXf

  
  #
  # Generic way of creating module types, used often when making decisions based off of <module>.type
  #
  
  WXFCORE = WXf::WXfdb::Core.new(WXFDIR, 1)
  
  DB_EXP = 'db_exploit'
  DB_PAY = 'db_payload'
  FILE_EXP = 'file_exploit'
  FILE_PAY = 'file_payload'
  CREATE_EXPLOIT = 'create_exploit'
  CREATE_PAYLOAD = 'create_payload'
  WEBSERVER = 'webserver'
  AUXILIARY = 'auxiliary'
  
  FUNCTION_TYPES = 
  [ 
    DB_EXP,
    DB_PAY,
    FILE_EXP,
    FILE_PAY,
    CREATE_EXPLOIT,
    CREATE_PAYLOAD,
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
  PayloadsDir = File.expand_path(File.join(File.dirname(__FILE__), '..','..','..')) + File::SEPARATOR + 'datum/payloads/'
  LogsDir = File.expand_path(File.join(File.dirname(__FILE__), '..')) + File::SEPARATOR + 'wXflog/' 

 
end
