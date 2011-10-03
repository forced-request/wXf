#!/usr/bin/env jruby

import javax.swing.JTree
import javax.swing.tree.DefaultMutableTreeNode
import javax.swing.tree.TreeModel
import javax.swing.tree.DefaultTreeModel
import javax.swing.tree.TreeSelectionModel

module WxfGui
class ModulesTree
  include TreeModel
  attr_reader :schema

  def initialize(s)
    @schema = s
  end

  def getChild(a,i)
    case a
    when "Modules"
      return @schema.types[i]
    when 'payload'
      return @schema.payload_names[i]
    when 'exploit'
      return @schema.exploit_names[i]
    when 'buby'
      return @schema.buby_names[i]
    when 'auxiliary'
      return @schema.auxiliary_names[i]
    else
      return 0
    end
  end
  
  def getChildCount(a)
    case a
    when 'Modules'
      return @schema.types.length
    when 'payload'
      return @schema.payload_names.length
    when 'exploit'
      return @schema.exploit_names.length
    when 'buby'
      return @schema.buby_names.length
    when 'auxiliary'
      return @schema.auxiliary_names.length
    else
      return 0
    end
  end
  
  def getIndexOfChild(a, h)
  end

  def getRoot()
    return @schema.root
  end

  def isLeaf(o)
    if o == @schema.root
      return false
    elsif @schema.types.include?(o) 
      return false
    else
      return true
    end 
  end
  
  def addTreeModelListener(l)
  end
  
  def removeTreeModelListener(l)
  end
  
  def valueForPathChanged(arg0, arg1)
  end
    
end

end
