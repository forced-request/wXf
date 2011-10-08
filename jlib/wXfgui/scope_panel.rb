#!/usr/bin/env jruby

import java.awt.FlowLayout
import java.awt.Dimension
import javax.swing.JPanel
import javax.swing.JScrollPane
import javax.swing.JTable
import javax.swing.JTextField
import javax.swing.JCheckBox
import javax.swing.JComboBox
import javax.swing.JButton
import java.awt.event.MouseListener
import javax.swing.table.DefaultTableModel

module WxfGui
   
class ScopePanelExtension < JPanel
   
   def initialize
      super(FlowLayout.new(FlowLayout::LEFT))
      init
   end
   
   def init
       combo_prefix = ["https", "http"]
       combo_box = JComboBox.new
       combo_prefix.each do |pre|
           combo_box.addItem(pre)
        end
        
       host_field = JTextField.new(14)
       port_field = JTextField.new(5)
       path_field = JTextField.new(22)
       
       add(combo_box)
       add(host_field)
       add(port_field)
       add(path_field)
       
   end
end
   
class ScopePanel < JPanel
  
   include MouseListener
  
  def initialize
    super
    init
  end
  
  def init
     
      
     
       spe = ScopePanelExtension.new
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
      p  = layout.createParallelGroup
      p1 = layout.createParallelGroup
      p2 = layout.createParallelGroup
      p3 = layout.createParallelGroup
      
      layout.setHorizontalGroup sh1
      layout.setVerticalGroup sv3
      
      
      p.addComponent(jpane)
      p.addComponent(spe)
      p1.addComponent(add_button)
      p1.addComponent(edit_button)
      p1.addComponent(rem_button)     
      sh1.addGroup(p)
      sh1.addGroup(p1)
      
      sv1.addComponent(jpane)
      sv1.addComponent(spe)
      sv1.addGroup(p3)
      
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