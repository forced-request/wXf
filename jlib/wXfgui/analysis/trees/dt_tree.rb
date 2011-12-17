#!/usr/bin/env jruby

require 'java'

import javax.swing.tree.TreeModel
import javax.swing.event.TreeModelListener

module WxfGui
  
  class DtTree
    
    include TreeModel
    attr_accessor :innerModel
  
    def initialize(dtl)
     @dtl = dtl
    end

  
    def getChild(obj, index)
      if (obj)
        if obj.to_s ==  "Decision Tree" #&& obj.kind_of?(DefaultMutableTreeNode)
         return @dtl[index]
        else
          return 0
        end
      end 
    end
  
    def getChildCount(parent)
      if (parent)
      if parent.to_s == "Decision Tree"
        return @dtl.length
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