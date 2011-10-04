#!/usr/bin/env jruby

require 'java'

import javax.swing.JCheckBox

module WxfGui
class DecisionTreeList < Hash
  
  def initialize
   decision_packages.each do |key, value|
     self.store(key, value)
   end
  end
  
  def decision_packages
    {
      
      "Basic Info" => [JCheckBox.new("HTTP Methods Allowed", false), JCheckBox.new("Header Enumeration", false)],
      "Default Content" => [JCheckBox.new("Google Filetypes", false), JCheckBox.new("Nikto", false), JCheckBox.new("DirBuster", false), JCheckBox.new("Google Admin Searches", false)]      
    }
    
  end

end
end 