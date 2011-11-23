require 'java'

import javax.swing.JFrame
import javax.swing.GroupLayout
import javax.swing.JPanel
import javax.swing.JTextArea
import javax.swing.JButton
import java.awt.TextArea
import javax.swing.JScrollPane
import java.awt.Dimension

module WxfGui
  
  class FileOpenPanel < JPanel
    
    def initialize(fc, frame)
      @frame = frame
      @fc = fc
      super()
      init
    end
    
    def init
      jb = JButton.new("Close")
    
      jt = TextArea.new()
      jt.editable = false
      jt.setPreferredSize(Dimension.new(700,800))
      js = JScrollPane.new(jt)
      jt.text = @fc
      
      jb.addActionListener do |e|
        @frame.dispose()
      end
      
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
      sv2 = layout.createSequentialGroup
      sv3 = layout.createSequentialGroup
      p1 = layout.createParallelGroup
      p2 = layout.createParallelGroup
      
      layout.setHorizontalGroup sh1
      layout.setVerticalGroup sv1
     
      sh1.addComponent(js)
      sh1.addComponent(jb)
      sv1.addComponent(js)
      sv1.addComponent(jb)
      
      
    end
  end
  
  class FileOpenFrame < JFrame
    def initialize(file_contents, file_name)
      @fc = file_contents
      super(file_name)      
      initUI
    end
  
    
    def initUI
      
      fpo = FileOpenPanel.new(@fc, self)
      self.add(fpo)
      
      self.setJMenuBar menuBar
      self.setPreferredSize Dimension.new(900, 900)
      self.pack
    
      self.setLocationRelativeTo nil
      self.setVisible true
    end
  
  end
end