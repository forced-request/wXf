#!/usr/bin/env jruby
#
# db.rb
# This is our main database handler, handling interactions with SQLite3 DB
#

require 'java'

begin  
  require 'rubygems'
  require 'jdbc/sqlite3'
rescue LoadError
  print("\e[1;31m[wXf error]\e[0m Please ensure you have the following gem installed:\n")
  print("1) jdbc-sqlite3\n")
  java.lang.System.exit 0
end

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import org.sqlite.JDBC;

module WXf
  module WXfdb
    
  class Db
    
    def initialize(db)
      db_file = db
      if File.exist?("#{db_file}")
        @db = "#{db_file}"
      else
        @db = nil
        puts(" #{db_file} does not exist")
      end
     rescue
    end
    
    def get_rfi_string_by_name(name)
      r_path = ''
      if not @db.nil?
        conn = DriverManager.getConnection("jdbc:sqlite:#{@db}")
        prep = conn.prepareStatement('SELECT r_path FROM rfi WHERE r_name= ?')
        prep.setString(1, name)
        result = prep.executeQuery
        while result.next()
          r_path = result.getString("r_path")
        end
        conn.close()
      end 
      return r_path
    end
    
    def get_rfi_requires_auth(name)
     r_require_auth = ''
      if not @db.nil?
        conn = DriverManager.getConnection("jdbc:sqlite:#{@db}")
        prep = conn.prepareStatement('SELECT  r_require_auth FROM rfi WHERE r_name= ?')
        prep.setString(1, name)
        result = prep.executeQuery
        while result.next()
          r_require_auth = result.getString("r_require_auth")
        end
        conn.close()
      end 
      return r_require_auth
    end
    
    
    def get_rfi_list
      rows = []
      if not @db.nil?
        conn = DriverManager.getConnection("jdbc:sqlite:#{@db}")
        stat = conn.createStatement()
        result = stat.executeQuery('SELECT * FROM rfi')
        while result.next()
          r_name = result.getString("r_name")
          r_desc = result.getString("r_desc")
          r_platform = result.getString("r_platform")
          r_lang = result.getString("r_lang")
          rows <<([r_name, r_desc, r_platform, r_lang])
        end
        conn.close()
      end
      return rows
    end
    
    
    def get_rfi_names
      rows = []
      if not @db.nil?
        conn = DriverManager.getConnection("jdbc:sqlite:#{@db}")
        stat = conn.createStatement()
        result = stat.executeQuery('SELECT r_name FROM rfi')  
        while result.next()
          r_name = result.getString("r_name")
          rows<<(r_name)
        end
        conn.close()
      end 
      return rows      
    end
    
    def get_rfi_by_name(name)
      rows = []
      if not @db.nil?
        conn = DriverManager.getConnection("jdbc:sqlite:#{@db}")
        prep = conn.prepareStatement('SELECT * FROM rfi WHERE r_name= ?')
        prep.setString(1, name)
        result = prep.executeQuery
        while result.next()          
         r_require_auth = result.getString("r_require_auth")
         r_platform = result.getString("r_platform")
         r_lang = result.getString("r_lang")
         r_path = result.getString("r_path")
         r_desc = result.getString("r_desc")
         r_name = result.getString("r_name")
         rows<<([r_require_auth, r_platform, r_lang, r_path, r_desc, r_name])
        end
        conn.close()
      end 
      return rows
    end
    
    def get_rfi_by_platform(platform)
      rows = []
      if not @db.nil?
        conn = DriverManager.getConnection("jdbc:sqlite:#{@db}")
        prep = conn.prepareStatement('SELECT r_path FROM rfi WHERE r_platform = ?')
        prep.setString(1, platform)
        result = prep.executeQuery
        while result.next()
          r_path = result.getString("r_path")
          rows<<(r_path)
        end
        conn.close()
      end 
      return rows         
    end
    
    def get_vuln_wordpress_plugins_list
      rows = []
      if not @db.nil?
        conn = DriverManager.getConnection("jdbc:sqlite:#{@db}")
        stat = conn.createStatement()
        result = stat.executeQuery('SELECT * FROM wordpress_vuln_plugins')
        while result.next()
         id = result.getInt("id")
         name = result.getString("name")
         title = result.getString("title")
         ref = result.getString("reference")
         rows<<([id, name, title, ref])
        end
        conn.close()
      end 
      return rows
    end
    
    def get_all_wordpress_plugins_list
      rows = []
      if not @db.nil?
        conn = DriverManager.getConnection("jdbc:sqlite:#{@db}")
        stat = conn.createStatement()
        result = stat.executeQuery('SELECT * FROM wordpress_plugins')
        while result.next()
         id = result.getInt("id")
         name = result.getString("name")
         rows<<([id, name])
        end
        conn.close()
      end 
      return rows
    end
    
    def get_wp_timthumb_list
      rows = []
      if not @db.nil?
        conn = DriverManager.getConnection("jdbc:sqlite:#{@db}")
        stat = conn.createStatement()
        result = stat.executeQuery('SELECT * FROM wordpress_timthumb')
        while result.next()
         id = result.getInt("id")
         name = result.getString("theme_name")
         path = result.getString("path")
         rows<<([id, name, path])
        end
        conn.close()
      end 
      return rows
    end
    
    def get_wordpress_vuln_by_name(name)
      rows = []
      if not @db.nil?
        conn = DriverManager.getConnection("jdbc:sqlite:#{@db}")
        prep = conn.prepareStatement('SELECT title, reference FROM wordpress_vuln_plugins WHERE name = ?')
        prep.setString(1, name)
        result = prep.executeQuery
        while result.next()
          title = result.getString("title")
          ref = result.getString("reference")
          rows<<([title, ref])
        end
        conn.close()
      end 
      return rows
    end
    
  end
  
end end



