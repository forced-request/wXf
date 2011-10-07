#!/usr/bin/env jruby


import javax.swing.JPanel
import javax.swing.JScrollPane
import javax.swing.JTable
import javax.swing.JCheckBox
import javax.swing.JButton
import java.awt.event.MouseListener
import javax.swing.table.DefaultTableModel

module WxfGui
class ScopePanel < JPanel
  
   include MouseListener
  
  def initialize
    super
    init
  end
  
  def init
     
        add_button  = JButton.new("add")
        edit_button = JButton.new("edit")
        rem_button  = JButton.new("remove")
     
 
         m = DefaultTableModel.new
         m.add_column("prefix")
         m.add_column("host")
         m.add_column("port")
         m.add_column("path")
         table = JTable.new(m)
         table.setPreferredScrollableViewportSize(Dimension.new(500, 70))
         table.setFillsViewportHeight(true)
        
        jpane = JScrollPane.new(table)
      
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
      p3 = layout.createParallelGroup
      
      layout.setHorizontalGroup sh1
      layout.setVerticalGroup sv3
      
      sh1.addComponent(jpane)
      p1.addComponent(add_button)
      p1.addComponent(edit_button)
      p1.addComponent(rem_button)     
      sh1.addGroup(p1)
      
      sv1.addComponent(jpane)
      sv2.addComponent(add_button)
      sv2.addComponent(edit_button)
      sv2.addComponent(rem_button)
      p2.addGroup(sv1)
      p2.addGroup(sv2)
      
      sv3.addGroup(p2)
      
      layout.linkSize SwingConstants::HORIZONTAL, 
          add_button, edit_button, rem_button
      
  
   

      
  end
end

end