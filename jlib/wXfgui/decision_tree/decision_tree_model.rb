#!/usr/bin/env jruby

require 'java'

import javax.swing.tree.TreeModel

module WxfGui
class DecisionTreeModel
  
  include TreeModel
  attr_reader :dtl
  
  def initialize(dtl)
    @dtl = dtl
    select_all
  end

  
  def getChild(obj, index)
    if (obj)
     if obj ==  "Decision Tree"
      return @dtl.keys[index]
     elsif @dtl.has_key?(obj)
       return @dtl[obj][index]
     else
      return 0
     end
    end 
  end
  
  def getChildCount(parent)
    if (parent)
     if parent == "Decision Tree"
      return @dtl.length
     elsif @dtl.has_key?(parent)
       return @dtl[parent].length
     else
      return 0  
     end
    end 
  end
  
  
  def getIndexOfChild(parent, child)
  end
  
  
  def root
     return "Decision Tree"
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
  
  def select_all
     @dtl.each do |k, row|
      row.each do |cb|
        cb.selected = true
      end   
    end
  end
  
  def deselect_all
     @dtl.each do |k, row|
      row.each do |cb|
        cb.selected = false
      end   
    end
  end
  
  def gray_out
     @dtl.each do |k, row|
      row.each do |cb|
        cb.enabled = false
      end   
    end
  end
  

  
  
  
end
end 