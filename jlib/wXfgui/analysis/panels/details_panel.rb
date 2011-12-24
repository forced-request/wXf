require 'java'

import java.io.BufferedReader
import java.io.FileReader


import javax.swing.JPanel

module WxfGui
  
  class DetailsPanel < JPanel
    
    def initialize(wXfgui)
      @wXfgui = wXfgui
      super()
      init
    end
    
    def init
      
      @textPane = JTextPane.new
      @textPane.editable = false
      @scp = JScrollPane.new(@textPane)
      
      #
      # GROUP LAYOUT OPTIONS
      #
      
      layout = GroupLayout.new self
      # Add Group Layout to the frame
      self.setLayout layout
      # Create sensible gaps in components (like buttons)
      layout.setAutoCreateGaps true
      layout.setAutoCreateContainerGaps true
    
      sh1 = layout.createSequentialGroup
      sv1 = layout.createSequentialGroup
      
      layout.setHorizontalGroup sh1
      layout.setVerticalGroup sv1      
      
      sv1.addComponent(@scp)
      sh1.addComponent(@scp)
         
    end
    
    def load_details
      mod = @wXfgui.base.in_focus.last
      mod_details = get_mod_details(mod)
      @textPane.text = mod_details
    end
    
    def clear_details
      @textPane.text = ''
    end
  
    def get_mod_details(mod)
      str = ''
      str << "Name: #{mod.name}\n"
      str << "Package: #{mod.package}\n"
      str << "Author: #{mod.author}\n"
      str << "Description: #{mod.desc}\n"
      str << "Requires Burp: #{mod.is_buby}\n"              
      str << "Required Modules: #{mod.required_modules}\n"
      str << "Optional Modules: #{mod.optional_modules}\n"
      return str
    end

  
  end
end