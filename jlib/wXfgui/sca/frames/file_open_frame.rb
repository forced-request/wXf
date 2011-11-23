require 'java'

import javax.swing.JFrame
import javax.swing.JPanel
import javax.swing.JTextArea
import java.awt.TextArea
import javax.swing.JScrollPane
import java.awt.Dimension

module WxfGui
  class FileOpenFrame < JFrame
    def initialize(file_contents, file_name)
      @fc = file_contents
      super(file_name)      
      initUI
    end
  
    
    def initUI
      
      jp = JPanel.new
     # jt = JTextArea.new()
      jt = TextArea.new()
      jt.editable = false
      jt.setPreferredSize(Dimension.new(700,800))
      js = JScrollPane.new(jt)
      jt.text = @fc
      
      jp.add(js)
      
      self.add(jp)
      
      self.setJMenuBar menuBar
      self.setPreferredSize Dimension.new(900, 900)
      self.pack
    
      self.setLocationRelativeTo nil
      self.setVisible true
    end
  
  end
end