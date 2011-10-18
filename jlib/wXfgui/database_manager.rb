#!/usr/bin/env jruby

require 'rubygems'
require  'find'
require 'wXfgui/notifications'

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
      create_scope_table(connection)
      connection.close()
    else
      Notifications.new("Workspace Error", "This workspace already exists, try another name")
      $db_name = nil
      error = "error"
     end
     return error    
  end
  
  def create_scope_table(conn)
    statement = conn.create_statement()
    statement.executeUpdate("CREATE TABLE scope(id INTEGER PRIMARY KEY AUTOINCREMENT, scope_status TEXT, prefix TEXT, host TEXT, port NUMERIC, path TEXT);")
    statement.executeUpdate("CREATE TABLE general(id INTEGER PRIMARY KEY AUTOINCREMENT, text TEXT, color TEXT, time TEXT);")
  end
  
end


module DatabaseManagerModule
  
  def retrieve_scope_table
    rows = []
    if not $db_name.nil?
      conn = DriverManager.getConnection("jdbc:sqlite:#{$db_name}")
      stat = conn.createStatement()
      result = stat.executeQuery('SELECT * FROM scope')
      while result.next()
        #id = result.getInt("id")
        scope_status = result.getString("scope_status")
        prefix = result.getString("prefix")
        host = result.getString("host")
        port = result.getInt("port")
        path = result.getString("path")      
        rows <<([scope_status, prefix, host, port, path])
      end
      conn.close()
    end     
    return rows
  end
  
  def db_add_scope(*params)
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

  
  def db_remove_scope_by_row(row_num)
    return unless row_num.to_i > 0
    num = row_num.to_i - 1
    rows = retrieve_scope_table    
    if rows.kind_of?(Array) and rows.length > 0
      delete_all_scope
      rows.delete_at(num)
      rows.each do |row|
        scope_status = row[0] 
        prefix = row[1]
        host = row[2]
        port = row[3].to_i
        path = row[4]        
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
  
   def retrieve_general_table
    rows = []
    if not $db_name.nil?
      conn = DriverManager.getConnection("jdbc:sqlite:#{$db_name}")
      stat = conn.createStatement()
      result = stat.executeQuery('SELECT * FROM general')
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
  
  def db_add_general_text(*params)
    if not $db_name.nil?
      text, color, time = params    
      conn = DriverManager.getConnection("jdbc:sqlite:#{$db_name}")
      prep = conn.prepareStatement("insert into general(text, color, time) VALUES (?,?,?);")
      prep.setString(1, text)
      prep.setString(2, color)
      prep.setString(3, time)
      prep.addBatch()
      prep.executeBatch()
      conn.close()
    end 
  end 
    
end 

end

