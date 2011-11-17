#!/usr/bin/env jruby

require 'java'

import javax.swing.GroupLayout
import java.awt.Color
import javax.swing.JFrame
import javax.swing.JPanel
import javax.swing.JTextField
import javax.swing.JTextArea
import javax.swing.JScrollPane
import java.awt.event.FocusListener
import java.awt.event.MouseListener
import java.awt.Dimension


#
#
# This is going to be an analysis tab where the decision tree works its magic
#
#
module WxfGui
class WxfConsolePanel < JPanel
  
   include MouseListener
   include FocusListener
  
  def initialize
    super
    init
  end
  
  def init
     
      ta = JTextArea.new(1200, 800)
      ta.setBackground(Color.black)
      js = JScrollPane.new(ta)
      tf = JTextField.new("wXf />>")
      tf.setBackground(Color.black)
      tf.setForeground(Color.green)
      
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
      p1 = layout.createParallelGroup
      
      layout.setHorizontalGroup sh1
      layout.setVerticalGroup sv1
      
      
      #p1.addComponent(js)
      p1.addComponent(ta)
      p1.addComponent(tf)
      sh1.addGroup(p1)
      #sv1.addComponent(js)
      sv1.addComponent(ta)
      sv1.addComponent(tf)
     
  end
  
end

=begin
#Test code within here


=end

class TestFrame < JFrame
  
  def initialize
    super("Unit Test")
    init
  end
  
  def init
     
  
    cp = WxfConsolePanel.new
    self.add(cp)
    
    self.setJMenuBar menuBar
    self.setPreferredSize Dimension.new(1300, 900)
    self.pack
    
    self.setDefaultCloseOperation JFrame::EXIT_ON_CLOSE
    self.setLocationRelativeTo nil
    self.setVisible true
    
  end
  
end 

end

#WxfGui::TestFrame.new

