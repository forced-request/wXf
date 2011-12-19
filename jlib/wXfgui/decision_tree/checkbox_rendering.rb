#!/usr/bin/env jruby

require 'java'

import javax.swing.JCheckBox
import java.awt.BorderLayout
import java.awt.Color
import java.awt.Component
import java.awt.Font
import java.awt.event.ItemEvent
import java.awt.event.ItemListener
import java.awt.event.MouseEvent
import java.util.EventObject

import javax.swing.AbstractCellEditor
import javax.swing.JCheckBox
import javax.swing.JFrame
import javax.swing.JScrollPane
import javax.swing.JTree
import javax.swing.UIManager
import javax.swing.event.ChangeEvent
import javax.swing.tree.DefaultMutableTreeNode
import javax.swing.tree.DefaultTreeCellEditor
import javax.swing.tree.DefaultTreeCellRenderer
import javax.swing.tree.TreeCellEditor
import javax.swing.tree.TreeModel
import javax.swing.tree.TreeCellRenderer
import javax.swing.tree.TreeNode
import javax.swing.tree.TreePath


module WxfGui
class CheckBoxNodeRenderer
  include TreeCellRenderer

  def initialize
    @leafRenderer = JCheckBox.new
    @nonLeafRenderer = DefaultTreeCellRenderer.new
  end
   
  def getTreeCellRendererComponent(tree, value, selected, expanded, leaf, row, hasFocus)
    if value.kind_of?(JCheckBox)
      returnValue = value
    else
      returnValue = @nonLeafRenderer.getTreeCellRendererComponent(tree, value, selected, expanded, leaf, row, hasFocus)
    end
   return returnValue
  end
  
  def getLeafRenderer()
    return @leafRenderer
  end
  
end

class CheckBoxNodeEditor < AbstractCellEditor
  include TreeCellEditor
  
  
  def initialize(tree, renderer)
    @renderer = renderer
    @tree = tree
    super()
  end

  def isCellEditable(event)
    returnValue = false
    if (event.kind_of?(MouseEvent)) 
      mouseEvent = event
      path = @tree.getPathForLocation(mouseEvent.getX(), mouseEvent.getY())
      if (path != nil) 
        node = path.getLastPathComponent()
        if (node != nil) and (node.kind_of?(JCheckBox))
          treeNode = DefaultMutableTreeNode.new(node)
          userObject = treeNode.getUserObject()
          returnValue = treeNode.isLeaf() and userObject
        end
       end 
    end
    return returnValue
  end
 
 
  def getCellEditorValue()
    checkbox = @renderer.getLeafRenderer()
    checkBoxNode = JCheckBox.new(checkbox.getText(), checkbox.isSelected())
    return checkBoxNode
  end


  def getTreeCellEditorComponent(tree, value, selected, expanded, leaf, row)
    editor = @renderer.getTreeCellRendererComponent(tree, value, true, expanded, leaf, row, true)
    
    if editor.kind_of?(JCheckBox)
      listener(editor)
    end
    return editor
  end
  
  def listener(editor)
    editor.add_item_listener do |e|
       if stopCellEditing == true
          fireEditingStopped()
       end
    end 
  end
  
end

end