require 'java'

import javax.swing.JFrame
import javax.swing.GroupLayout
import javax.swing.JPanel
import javax.swing.JButton
import javax.swing.JTextPane
import javax.swing.JScrollPane
import java.awt.Dimension
import java.awt.Point

module WxfGui
  
  class FileOpenPanel < JPanel
    
    def initialize(fc, num, frame)
      @num = num.to_i
      @frame = frame
      @fc = fc
      super()
      init
    end
    
    def init
      
      jb = JButton.new("Close")
      jp = JPanel.new(BorderLayout.new)
      @jt = JTextPane.new()
      @jt.editable = false
      @jt.setPreferredSize(Dimension.new(700,800))
      js = JScrollPane.new(@jt)
      jp.add(js)
      @doc = @jt.getStyledDocument()
      
      # Add color
      add_colors
      
      # Added a button to close JButton 
      jb.addActionListener do |e|
        @frame.dispose()
      end
    
      insert_string
         
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
     
      sh1.addComponent(jp)
      sh1.addComponent(jb)
      sv1.addComponent(jp)
      sv1.addComponent(jb)
      
    end
    
    def add_colors
      # Yellow
      style = @jt.addStyle("Yellow", nil)
      StyleConstants.setBold(style, true);
      StyleConstants.setBackground(style, Color.yellow)
      
      # Bold
      style2 = @jt.addStyle("Bold", nil)
      StyleConstants.setBold(style2, true)
    end
    
    def insert_string
      @fc.each_with_index do |line, idx|
        idx +=1
        if idx == @num
          @doc.insertString(@doc.getLength(), line, @jt.getStyle("Yellow"))
        else
          @doc.insertString(@doc.getLength(), line, @jt.getStyle("Bold"))
        end 
      end
    end
    
  end
  
  class FileOpenFrame < JFrame
    def initialize(file_contents, line_number, file_name)
      @line_number = line_number
      @fc = file_contents
      super(file_name)      
      initUI
    end
  
    
    def initUI
      
      fpo = FileOpenPanel.new(@fc, @line_number, self)
      self.add(fpo)
      
      self.setJMenuBar menuBar
      self.setPreferredSize Dimension.new(900, 900)
      self.pack
    
      self.setLocationRelativeTo nil
      self.setVisible true
    end
  
  end
end