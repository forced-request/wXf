#!/usr/bin/env jruby

require 'rubygems'
require 'jdbc/sqlite3'
require  'find'

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
    @name = name
    init_db
   
  end
  
  def init_db
    home_dir = ENV['HOME']
    wXf_home_dir = "#{home_dir}/.wXf"    
    connection = DriverManager.getConnection("jdbc:sqlite:#{wXf_home_dir}/#{@name}.db")
  end 
end 

end

