#!/usr/bin/env jruby

require 'java'

import javax.swing.JTabbedPane
import javax.swing.GroupLayout
import java.awt.Color
import javax.swing.JButton
import java.awt.FlowLayout
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
class ScaPanel < JPanel
  
   include MouseListener
   include FocusListener
  
  def initialize
    super
    init
  end
  
  def init
     
      # Panels
      jp1 = JPanel.new(FlowLayout.new(FlowLayout::LEFT))
      jp2 = JPanel.new(FlowLayout.new(FlowLayout::LEFT))
      jp3 = JPanel.new(FlowLayout.new(FlowLayout::LEFT))
      
      # Text Fields
      tf1 = JTextField.new(20)
      tf2 = JTextField.new(20)
     
      # Text area
      ta = JTextArea.new(450, 200)
      ta.setBackground(Color.black)
      ta.setForeground(Color.green)
      
      # Scroll pane
      js1 = JScrollPane.new(ta)
      
      
      # Buttons
      chooseDir = JButton.new("choose")
      searchButton = JButton.new("search")
      
      
      # Add stuff to panels
      jp1.add(tf1)
      jp2.add(tf2)
      jp3.add(ta)
      
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
      sh2 = layout.createSequentialGroup
      sh3 = layout.createSequentialGroup
      sv1 = layout.createSequentialGroup
      sv2 = layout.createSequentialGroup
      sv3 = layout.createSequentialGroup
      p1 = layout.createParallelGroup
      p2 = layout.createParallelGroup
      p3 = layout.createParallelGroup
      
      layout.setHorizontalGroup sh3
      layout.setVerticalGroup sv3
      
      
      # Horizontal
      p1.addComponent(jp1)
      p1.addComponent(jp2)
      p1.addComponent(jp3)
      sh1.addGroup(p1)
      p2.addComponent(chooseDir)
      p2.addComponent(searchButton)
      sh2.addGroup(p2)
      sh3.addGroup(sh1)
      sh3.addGroup(sh2)
      
      # Vertical
      sv1.addComponent(jp1)
      sv1.addComponent(jp2)
      sv1.addComponent(jp3)
      sv2.addComponent(chooseDir)
      sv2.addComponent(searchButton)
      p3.addGroup(sv1)
      p3.addGroup(sv2)
      sv3.addGroup(p3)

     
  end
  
end


class WxfScaPanel < JTabbedPane
   
   def initialize
      super(JTabbedPane::TOP, JTabbedPane::SCROLL_TAB_LAYOUT)
      init
   end
   
   def init
    cp = ScaPanel.new
    self.add("Regexp Search", cp)
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
     
    
    smp = WxfScaPanel.new
    
    self.add(smp)
    
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
