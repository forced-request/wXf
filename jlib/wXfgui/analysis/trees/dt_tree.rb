#!/usr/bin/env jruby

require 'java'

import javax.swing.tree.TreeModel
import javax.swing.event.TreeModelListener

module WxfGui
  
  class DtTree
    
    include TreeModel
    attr_accessor :innerModel
  
    def initialize
      self.innerModel = DefaultTreeModel.new(root);
    end

  
    def getChild(obj, index)
      if (obj)
        if obj.to_s ==  "Decision Tree" && obj.kind_of?(DefaultMutableTreeNode)
         return innerModel.getChild(obj,index) 
        #  return @dtl.keys[index]
        #elsif @dtl.has_key?(obj)
         # return @dtl[obj][index]
        else
          return 0
        end
      end 
    end
  
    def getChildCount(parent)
      if (parent)
      if parent.to_s == "Decision Tree" && parent.kind_of?(DefaultMutableTreeNode)
         return innerModel.getChildCount(parent)
       # elsif @dtl.has_key?(parent)
        #  return @dtl[parent].length
        else
          return 0  
        end
      end 
    end
  
  
    def getIndexOfChild(parent, child)
    end
  
  
    def root
     return DefaultMutableTreeNode.new("Decision Tree")
    end
  
    def getRoot()
      return @innerModel.root
    end
  
    def isLeaf(arg0)
       return innerModel.isLeaf(arg0)
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