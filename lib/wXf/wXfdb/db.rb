# db.rb
# This is our main database handler, handling interactions with SQLite3 DB
# 
# created 2010-03-23 by seth
#
begin

  require 'rubygems'
# Users need to do the following
# sudo apt-get install sqlite3
# sudo apt-get install libsqlite3-dev
# sudo gem install sqlite3-ruby

  require 'sqlite3'

rescue LoadError

  print("\n\n\n" +'WXF ALERT!!!! Please install sqlite3...' + "\n")
  print("\nUsers need to do the following:" +"\n")
  print("-------------------------------" +"\n")
  print("sudo apt-get install sqlite3" +"\n")
  print("sudo apt-get install libsqlite3-dev" +"\n")
  print('sudo gem install sqlite3 OR sudo gem install sqlite3-ruby (Ubuntu)' + "\n")
  
end
  
  
module WXf
module WXfdb

class Db
  
  def initialize(dir,lh)
    @loghandler = lh
    @loghandler.debug(2,"initializing Wxfdb")
    @db_file = 'datum/wXf.db'
    if File.exist?(dir + "/" + @db_file)
      @db = SQLite3::Database.new(dir + "/" + @db_file)
    else 
      @loghandler.error("Error: " + @db_file + "does not exist")

    end
rescue
  end
  
  def test
    @loghandler.debug(2,"calling Wxfdb.test")
    rows = @db.execute('SELECT * FROM exploits')
    rows.each do |row|
      puts "Row 1: #{row}"
    end
  end
  
  # get_exploit_list
  # returns an array of exploits with each exploit as [ id, name, desc ]
  def get_exploit_list
    @loghandler.debug(2,"calling Wxfdb.get_exploit_list")
    @db.execute('SELECT e_id,e_name,e_desc FROM exploits')
rescue
  end
  
  # get_exploit_by_id
  # returns all relevant information from the exploits table
  def get_exploit_by_id(input_id)
    @loghandler.debug(2,"calling Wxfdb.get_exploit_by_id(#{input_id})")
    @db.execute('SELECT * FROM exploits WHERE e_id=:id', "id"=>input_id)

  end

  # get_exploit_by_name
  # returns all relevant information from the exploits table
  def get_exploit_by_name(input_name)
    @loghandler.debug(2,"calling Wxfdb.get_exploit_by_name(#{input_name})")
    @db.execute('SELECT * FROM exploits WHERE e_name=:name', "name"=>input_name)
  end
  
  # get_exploit_by_name
  # returns all relevant information from the exploits table
  def get_exploit_val_by_name(input_name)
    @loghandler.debug(2,"calling Wxfdb.get_exploit_val_by_name(#{input_name})")
    @db.execute('SELECT e_values FROM exploits WHERE e_name=:name', "name"=>input_name)[0][0]
  end
  
  # create_exploit
  # 
  # create a new exploit
  def create_exploit(options)
    name = options['NAME']
    desc = options['DESC']
    type = options['TYPE']
    lang = options['LANG']
    method = options['METHOD']
    url = options['URL']
    headers = options['HEADERS']
    params = options['PARAMS']
    values = options['VALUES']
    stmt = "insert into exploits (e_name,e_desc,e_type,e_lang,e_method,e_url,e_headers,e_params,e_values) VALUES (?,?,?,?,?,?,?,?,?)"
    @loghandler.debug(2,"creating new exploit #{name}")
    begin
      @db.execute(stmt,name,desc,type,lang,method,url,headers,params,values)
    rescue
      @loghandler.error("Error on db insert: #{$!}")
    end
  end
  
  # create_payload
  # create a new payload
  def create_payload(options)
    name = options['NAME']
    desc = options['DESC']
    type = options['TYPE']
    lang = options['LANG']
    content = options['CONTENT']
    url = options['URL']
    params = options['PARAMS']
    values = options['VALUES']
    req = options['WEBSERVER_REQUIRED']
    stmt = "insert into payloads (p_name,p_desc,p_type,p_lang,p_content,p_values,p_url,p_params,p_requires_webserver) VALUES (?,?,?,?,?,?,?,?,?)"
    @loghandler.debug(2,"creating new payload #{name}")
    begin
      @db.execute(stmt,name,desc,type,lang,content,values,url,params,req)
    rescue
      @loghandler.error("Error on db insert: #{$!}")
    end
  end
    
  # get_payload_list
  # returns an array of all payloads with each payload as [ id, name, desc ]
  def get_payload_list
    @loghandler.debug(2,"calling Wxfdb.get_payload_list")
    @db.execute('SELECT p_id,p_name,p_desc FROM payloads')
rescue
  end
  
  # get_payload_by_id
  # returns all relevant information about a specific payload from the 
  # payloads table
  def get_payload_by_id(input_id)
    @loghandler.debug(2,"calling Wxfdb.get_payload_by_id(#{input_id})")
    @db.execute('SELECT * FROM payloads WHERE p_id=:id', "id"=>input_id)
  end
  
    # get_payload_by_name
    # returns all relevant information about a specific payload from the 
    # payloads table
    def get_payload_by_name(input_name)
      @loghandler.debug(2,"calling Wxfdb.get_payload_by_name(#{input_name})")
      @db.execute('SELECT * FROM payloads WHERE p_name=:name', "name"=>input_name)
    end
  
  def close
    @loghandler.debug(2,"calling Wxfdb.close")
    if ! @db.closed?()
      @db.close
    end
  end

end

end
end