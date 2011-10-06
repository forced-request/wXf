#!/usr/bin/env jruby

require 'java'

import javax.swing.tree.TreeModel

module WxfGui
class WorkspaceChooserModel
  
  include TreeModel
  attr_reader :schema
  
  def initialize(schema)
    @schema = schema
  end

  
  def getChild(obj, index)
    case (obj)
    when "Workspace(s)"
      return @schema[index]
    else
      return 0
    end
  end
  
  def getChildCount(parent)
    case(parent)
     when "Workspace(s)"
      return @schema.length
     else
      return 0  
    end 
  end
  
  def getIndexOfChild(parent, child)
  end
  
  
  def root
     return "Workspace(s)"
  end
  
  def getRoot()
    return root
  end
  
  def isLeaf(arg0)
    if arg0.kind_of?(String)
      return false
    elsif arg0.kind_of?(JCheckBox)
      return true
    end
  end
  
  
  def addTreeModelListener(arg0)
  end
  
  def removeTreeModelListener(arg0)   
  end
  
  def valueForPathChanged(arg0, arg1)
  end
  
  
end

end