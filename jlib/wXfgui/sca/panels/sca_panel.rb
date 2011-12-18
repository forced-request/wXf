#!/usr/bin/env jruby


# NOTE to users...
# To increase the size of memory it runs in -  $ jruby -J-Xmx2048m wXfgui

require 'rubygems'
require 'java'
require 'find'

import javax.swing.ListSelectionModel
import javax.swing.table.DefaultTableModel
import javax.swing.JTable
import javax.swing.JTabbedPane
import javax.swing.SwingConstants
import javax.swing.GroupLayout
import java.awt.BorderLayout
import java.awt.Color
import javax.swing.JButton
import java.awt.FlowLayout
import javax.swing.JFileChooser
import javax.swing.JFrame
import javax.swing.JOptionPane
import javax.swing.JPanel
import javax.swing.JTextField
import javax.swing.JTextArea
import javax.swing.JScrollPane
import java.awt.event.FocusListener
import java.awt.event.MouseListener
import java.awt.Dimension
import javax.swing.JSeparator
import javax.swing.JLabel



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
      jp1 = DataEntryPanel.new(self)
      jp2 = JPanel.new(FlowLayout.new(FlowLayout::LEFT))
      
      # Table area
       @results_table = ResultsTable.new
       @table = JTable.new(@results_table)
       @table.show_vertical_lines = true
       @table.show_grid = true
       @table.grid_color = Color.gray
       @table.setPreferredScrollableViewportSize(Dimension.new(1000, 400))
       @table.setFillsViewportHeight(true)
       @table.setSelectionMode(ListSelectionModel.SINGLE_SELECTION)
       
      
       
      # Scroll pane
      @js1 = JScrollPane.new(@table)
      jp2.add(@js1)
      
      @table.addMouseListener(ScaPopupMenu.new(@table))
      
          
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
      
      layout.setHorizontalGroup sh1
      layout.setVerticalGroup sv3 
      
      # Horizontal
      p1.addComponent(jp1)
      p1.addComponent(jp2)
      sh1.addGroup(p1)
      
      # Vertical
      sv1.addComponent(jp1)
      sv1.addComponent(jp2)
      sv3.addGroup(sv1)
       
  end
  
   def restore
      @results_table.restore
   end 
  
   def results_table
      return @results_table
   end
  
end


class WxfScaPanel < JTabbedPane
   
   def initialize
      super(JTabbedPane::TOP, JTabbedPane::SCROLL_TAB_LAYOUT)
      init
   end
   
   def init
    @cp = ScaPanel.new
    jpanel = JPanel.new()
    jpanel.setLayout(BorderLayout.new())
    jpanel.add(@cp, BorderLayout::LINE_START)
    jpanel2 = JPanel.new
    jpanel2.setLayout(BorderLayout.new())
    jpanel2.add(jpanel, BorderLayout::PAGE_START)
    self.add("String Search", jpanel2)
   end
   
   def restore
      @cp.restore
   end
end


#Test code within here

class TestFrame < JFrame
  
  def initialize
    super("Unit Test")
    init
  end
  
  def init
     
    smp = WxfScaPanel.new
    
    self.add(smp)
    self.pack
    self.setSize(Dimension.new(1300,900))
    
    self.setDefaultCloseOperation JFrame::EXIT_ON_CLOSE
    self.setLocationRelativeTo nil
    self.setVisible true
    
  end
  
end

# End Test Code

end



#WxfGui::TestFrame.new

