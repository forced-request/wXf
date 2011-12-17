#!/usr/bin/env jruby

require 'java'

import javax.swing.tree.TreeModel
import javax.swing.event.TreeModelListener

module WxfGui
  
  class DtTree
    
    include TreeModel
    attr_reader :dtl
  
    def initialize(dtl)
     @dtl = dtl
    end

  
  def getChild(obj, index)
    if (obj)
     if obj ==  "Decision Tree"
      return @dtl.keys[index] #if @dtl[index] != nil
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
       if arg0.to_s == "Decision Tree"
         return false
       elsif @dtl.has_key?(arg0.to_s)
         return false
       else
         return true
       end
    end
  
    def addTreeModelListener(listener)
    end
  
    def removeTreeModelListener(arg0)   
    end
  
    def valueForPathChanged(arg0, arg1)
    end
  
  end
  
  class DtTreeModelListener
    include TreeModelListener
    
    def treeNodesChanged(event)
    end
    
    def treeNodesInserted(event)
    end
    
    def treeNodesRemoved(event)
    end
    
    def treeStructureChanged(event)
    end
    
  end
  
  
end