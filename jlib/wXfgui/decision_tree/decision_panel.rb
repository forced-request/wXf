#!/usr/bin/env jruby

require 'java'

import java.awt.FlowLayout
import java.awt.Dimension
import javax.swing.JPanel
import javax.swing.JScrollPane
import javax.swing.JComboBox
import javax.swing.JButton
import java.awt.event.MouseListener
import javax.swing.GroupLayout

module WxfGui
class DecisionPanel < JPanel
  
  def initialize
    super
    init    
  end

  def init
      
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
      p1  = layout.createParallelGroup
      p2 = layout.createParallelGroup
      
      layout.setHorizontalGroup sh1
      layout.setVerticalGroup sv1
    
      
      dtm = DecisionTreeFactory.new
      dtm_modules = dtm.module_hash
      decisionTreeModel = DecisionTreeModel.new(dtm_modules)   
      
      @dt = JTree.new(decisionTreeModel)
      renderer = CheckBoxNodeRenderer.new
      @dt.set_cell_renderer(renderer)    
      @dt.cell_editor = CheckBoxNodeEditor.new(@dt, renderer)
      @dt.editable = true
      @dt.shows_root_handles = true
      @dt.addMouseListener(ModulesPopUpClickListener.new(@dt))
   
      expand_all(false)
     
   
      tree_scroll_pane = JScrollPane.new(@dt)
      
      select_all_button  = JButton.new("select all")
      deselect_all_button  = JButton.new("deselect all")
      
      select_all_button.add_action_listener do |e|
        decisionTreeModel.select_all
        @dt.repaint()
      end
      
      deselect_all_button.add_action_listener do |e|
        decisionTreeModel.deselect_all
        @dt.repaint()
      end
      
      p1.addComponent(select_all_button)
      p1.addComponent(deselect_all_button)
      sh1.addComponent(tree_scroll_pane)
      sh1.addGroup(p1)
      
      sv2.addComponent(tree_scroll_pane)
      sv3.addComponent(select_all_button)
      sv3.addComponent(deselect_all_button)
      p2.addGroup(sv2)
      p2.addGroup(sv3)
      sv1.addGroup(p2)
      
      layout.linkSize SwingConstants::HORIZONTAL, 
          deselect_all_button, select_all_button
      
  end
 
 
    def expand_all(bool)
      #additional expansion code for testing and later use
      total_count = @dt.getRowCount()
      count = 0
      paths = []
      while count < total_count
        paths<<(@dt.getPathForRow(count))#.getLastPathComponent())
        count +=1
      end  
      paths.each_with_index do |item, idx|
        if bool == true
          @dt.expandPath(item)
        elsif bool == false
          @dt.collapsePath(item)
        end 
      end
    end
  
end
end 

