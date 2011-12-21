require 'java'

import javax.swing.JPanel

module WxfGui
  
  class InfoPanel < JPanel
    
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
    
    def load_info
      file = @wXfgui.base.in_focus.last.info_file
      if File.exists?(file) && File.file?(file)
        text = read_file(file)
        @textPane.text = text
      else
        @textPane.text = no_file
      end
    end
    
    def no_file
      str = ''
      str << 'No information file was found, no information available at this time.'
      return str
    end
    
    def clear_info
      @textPane.text = ''
    end
    
    def read_file(file_path)
      new_str = ''
      fileReader = FileReader.new(file_path)
      bufferReader = BufferedReader.new fileReader
      str = bufferReader.readLine

      while str
        new_str << str.to_s
        str = bufferReader.readLine
      end
      bufferReader.close
      return new_str  
    end
  
  end
end