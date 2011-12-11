#!/usr/bin/env jruby

require 'rubygems'
require  'find'

#require 'wXfgui/notifications'

require 'java'

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import org.sqlite.JDBC;

module WxfGui
class DatabaseManager

  def initialize(name)
    $db_name = "#{WXf::WXF_HOME_DIR}/#{name}.db"
  end
  
  def init_db
    error = ''
     if !File.exists?($db_name)
      connection = DriverManager.getConnection("jdbc:sqlite:#{$db_name}")
      create_all_tables(connection)
      connection.close()
    else
      Notifications.new("Workspace Error", "This workspace already exists, try another name")
      $db_name = nil
      error = "error"
     end
     return error    
  end
  
  def create_all_tables(conn)
    statement = conn.create_statement()
    statement.executeUpdate("CREATE TABLE scope(id INTEGER PRIMARY KEY AUTOINCREMENT, scope_status TEXT, prefix TEXT, host TEXT, port NUMERIC, path TEXT);")
    statement.executeUpdate("CREATE TABLE log(id INTEGER PRIMARY KEY AUTOINCREMENT, text TEXT, color TEXT, time TEXT);")
    statement.executeUpdate("CREATE TABLE string_search_results(id INTEGER PRIMARY KEY, file TEXT, line_number TEXT, string_match TEXT, ext TEXT)")
  end
  
end


module ScopeDatabaseManagerModule
  
  def retrieve_scope_table
    rows = []
    if not $db_name.nil?
      conn = DriverManager.getConnection("jdbc:sqlite:#{$db_name}")
      stat = conn.createStatement()
      result = stat.executeQuery('SELECT * FROM scope')
      while result.next()
        id = result.getInt("id")
        scope_status = result.getString("scope_status")
        prefix = result.getString("prefix")
        host = result.getString("host")
        port = result.getInt("port")
        path = result.getString("path")      
        rows <<([id, scope_status, prefix, host, port, path])
      end
      conn.close()
    end     
    return rows
  end
  
  def db_add_scope(*params)
    if not $db_name.nil?
      scope_status, prefix, host, port, path = params
      conn = DriverManager.getConnection("jdbc:sqlite:#{$db_name}")
      prep = conn.prepareStatement("insert into scope(scope_status, prefix, host, port, path) VALUES (?,?,?,?,?);")
      prep.setString(1, scope_status)
      prep.setString(2, prefix)
      prep.setString(3, host)
      prep.setInt(4, port)
      prep.setString(5, path)
      prep.addBatch()
      prep.executeBatch()
      conn.close()
    end
  end

  
  def db_remove_scope_by_row(row_num)
    return unless row_num.to_i > 0
    num = row_num.to_i - 1
    rows = retrieve_scope_table    
    if rows.kind_of?(Array) and rows.length > 0
      delete_all_scope
      rows.delete_at(num)
      rows.each do |row|
        id = row[0]
        scope_status = row[1] 
        prefix = row[2]
        host = row[3]
        port = row[4].to_i
        path = row[5]        
        db_add_scope(scope_status, prefix, host, port, path)
      end
    end
  end
  
  def delete_all_scope
    conn= DriverManager.getConnection("jdbc:sqlite:#{$db_name}")
    stmt = conn.create_statement()
    stmt.executeUpdate('delete from scope')
    conn.close
  end
end  
 
module LogDatabaseManagerModule
  
   def retrieve_log_table
    rows = []
    if not $db_name.nil?
      conn = DriverManager.getConnection("jdbc:sqlite:#{$db_name}")
      stat = conn.createStatement()
      result = stat.executeQuery('SELECT * FROM log')
      while result.next()
        text = result.getString("text")
        color = result.getString("color")
        time = result.getString("time")
        rows <<([text, color, time])
      end
      conn.close()
    end 
    return rows
  end
  
  def db_add_log_text(*params)
    if not $db_name.nil?
      text, color, time = params    
      conn = DriverManager.getConnection("jdbc:sqlite:#{$db_name}")
      prep = conn.prepareStatement("insert into log(text, color, time) VALUES (?,?,?);")
      prep.setString(1, text)
      prep.setString(2, color)
      prep.setString(3, time)
      prep.addBatch()
      prep.executeBatch()
      conn.close()
    end 
  end
end

module ScaDatabaseManagerModule
  
  def db_add_string_results(*params)
    if not $db_name.nil?
      file, line_number, string_match, ext = params
      conn = DriverManager.getConnection("jdbc:sqlite:#{$db_name}")
      prep = conn.prepareStatement("insert into string_search_results(file, line_number, string_match, ext) VALUES (?,?,?,?);")
      prep.setString(1, file)
      prep.setString(2, line_number)
      prep.setString(3, string_match)
      prep.setString(4, ext)
      prep.addBatch()
      prep.executeBatch()
      conn.close()
    end
  end
  
  def retrieve_string_results
    rows = []
    if not $db_name.nil?
      conn = DriverManager.getConnection("jdbc:sqlite:#{$db_name}")
      stat = conn.createStatement()
      result = stat.executeQuery('SELECT * FROM string_search_results')
      while result.next()
        #id = result.getInt("id")
        file = result.getString("file")
        line_number = result.getString("line_number")
        string_match = result.getString("string_match")
        ext = result.getString("ext")
        rows <<([file, line_number, string_match, ext])
      end
      conn.close()
    end     
    return rows
  end
    
end 

end

