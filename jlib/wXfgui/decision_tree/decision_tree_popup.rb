#!/usr/bin/env ruby

require 'java'

java_import javax.swing.JMenuItem
java_import javax.swing.JPopupMenu
java_import java.awt.event.MouseAdapter

module WxfGui
class ChecklistPopUpItem < JPopupMenu

  
  def initialize(tree)
    super()
    @tree = tree
  end
  
  def show_it(event)
    node = @tree.getSelectionPath
    path = normalize_path(node)
    
    if path.length == 3
      self.show(event.getComponent(), event.getX(), event.getY());
    end 
  end
  
  def normalize_path(node)
    path = []
    if not node.nil?
      node_string = node.to_s
      path = node_string[1..-2].split(',').collect! {|n| n.to_s}
    end 
    return path    
  end

end

class SelectChecklistListener < MouseAdapter
  
  def initialize(menu_item)
    @menu_item = menu_item
    super()
  end
  
  def mousePressed(event)
   
  end
  
  def mouseReleased(event)
  end
  
  def test_popup(event)
  end
  
end

class ChecklistPopUpClickListener < MouseAdapter
  
  def initialize(tree)
    super()
    @pop_up = ChecklistPopUpItem.new(tree)
  end
  
  def mousePressed(event)
    if event.isPopupTrigger
     test_popup(event)
    end
  end
  
  def mouseReleased(event)
    if event.isPopupTrigger
      test_popup(event)
    end
  end
  
  def test_popup(event)
    @pop_up.show_it(event)
  end
  
end

end 
