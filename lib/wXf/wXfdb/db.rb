# db.rb
# This is our main database handler, handling interactions with SQLite3 DB
# 
# New as of July 3, 2011.
#
begin
  
  require 'rubygems'

  require 'sqlite3'

rescue LoadError
  print("\n\e[1;31m[wXf error]\e[0m Please install sqlite3\n")
  print("\nUsers need to do the following:" +"\n")
  print("-------------------------------" +"\n")
  print("sudo apt-get install sqlite3" +"\n")
  print("sudo apt-get install libsqlite3-dev" +"\n")
  print('sudo gem install sqlite3-ruby' + "\n\n")
  exit
end
  
  
module WXf
module WXfdb

  class Db
 
    def initialize(db)
      @db_file = db
      if File.exist?("#{@db_file}")
        @db = SQLite3::Database.new("#{@db_file}")
      else
        puts(" #{@db_file} + does not exist")
      end
     rescue
    end
  
    def get_rfi_string_by_name(name)
     result = []
      if File.exists?(@db_file)
        result =  @db.execute('SELECT r_path FROM rfi WHERE r_name=:name', "name" => name)
      end  
      if result.empty?
        raise "No RFI by that name"
      else
       return result
      end 
    end
    
    
    def get_rfi_requires_auth(name)
      result = []
      if File.exists?(@db_file)
        result =  @db.execute('SELECT r_require_auth FROM rfi WHERE r_name=:name', "name" => name)
      end  
      if result.empty?
       raise "No RFI by that name"
      else
        return result
      end
    end
    
    def get_rfi_list
      result = []     
      if File.exists?(@db_file)
        result = @db.execute('SELECT r_name, r_desc, r_platform, r_lang FROM rfi')
      end 
      return result
     rescue    
    end
    
    def get_rfi_names
          result = []
          if File.exists?(@db_file)
           result = @db.execute('SELECT r_name FROM rfi')
          end  
          if result.empty?
            raise "No RFI by that name"
          else
            return result
          end
    end
  
    def get_rfi_by_name(name)
      result = []
      if File.exists?(@db_file)
       result = @db.execute('SELECT * FROM rfi WHERE r_name=:name', "name" => name)
      end  
      if result.empty?
        raise "No RFI by that name"
      else
        return result
      end
    end
    
    def get_rfi_by_platform(platform)
      result = []
      if File.exists?(@db_file)
        result = @db.execute('SELECT r_path FROM rfi WHERE r_platform=:platform', "platform" => platform)
      end  
      if result.empty?
        raise "No RFI by that name"
      else
        return result
      end  
    end
    
    def get_vuln_wordpress_plugins_list
      result = []
      if File.exists?(@db_file)
        result = @db.execute('SELECT * FROM wordpress_vuln_plugins')
      end  
      if result.empty?
        raise "No data"
      else
        return result
      end  
    end
    
    def get_all_wordpress_plugins_list
      result = []
      if @db_file == "wXf.db"
        result = @db.execute('SELECT * FROM wordpress_plugins' )
      end  
      if result.empty?
        raise "No data"
      else
        return result
      end  
    end
    
    def get_wordpress_vuln_by_name(name) 
      result = []
      if @db_file == "wXf.db"
        result =  @db.execute('SELECT title, reference FROM wordpress_vuln_plugins WHERE name=:name', "name" => name)
      end  
      if not result.empty?
       return result
      end 
    end

  end

end end
