=begin
# This code can be used for an individual path/branch if we'd like.
      while count < total_count
        paths<<(tree.getPathForRow(count))
        count +=1
      end  
      paths.each_with_index do |item, idx|
          tree.expandPath(item)
      end
=end
module WxfGui
  module ExpandCollapse
    
    def expand_all(tree)
      return unless tree.kind_of?(JTree)
      total_count = tree.getRowCount()
      count = 0
      paths = []
      
      while count < tree.getRowCount()       
        tree.expandRow(count)
        count +=1
      end
      
    end
    
    def collapse_all(tree)
      return unless tree.kind_of?(JTree)
      total_count = tree.getRowCount()
      count = 0
      paths = []
      
      while count < total_count
        paths<<(tree.getPathForRow(count))
        count +=1
      end  
      paths.reverse.each_with_index do |item, idx|
          tree.collapsePath(item)
      end             
    end
    
  end
end