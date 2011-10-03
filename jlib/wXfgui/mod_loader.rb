#!/usr/bin/env jruby

require 'find'

module WxfGui
class ModLoader
  
  attr_accessor :payload_names, :exploit_names, :buby_names, :auxiliary_names

  def initialize
    location = WXf::ModWorkingDir
    load_mod(location)
    self.payload_names = []  
    self.buby_names = []
    self.exploit_names =[]
    self.auxiliary_names =[]
    names
  end
  
  def load_mod(base_path)
    @file_array = []
    Find.find(base_path) do |file|     
      if (file =~ /.rb/) and if not (file.match(/svn/))
        path = file.sub(base_path + "/", '').sub(/.rb/, '')
        type = path.sub(/\/.*/, '')
        path.sub!("#{type}/", '')
        @file_array <<([type, path])
      end
     end
    end 
  end
  
  def type_count
    counts = []
    @file_array.each do |type, name|
      counts << type
    end
    return counts.length
  end
 
  def name_count
    counts = []
    @file_array.each do |type, name|
      counts << name
    end
    return counts.length
  end
 
  def types
    types = []
    @file_array.each do |type, name|
      if not types.include?(type)
        types << type
      end 
    end
    return types
  end
  
  def names
    @file_array.each do |type, name|
     case type
     when 'payload'
       payload_names <<(name)
     when 'auxiliary'
       auxiliary_names <<(name)
     when 'buby'
       buby_names <<(name)
     when 'exploit'
       exploit_names <<(name)
     end
    end
  end
  
  
  
  def root
    "Modules"
  end

end

end