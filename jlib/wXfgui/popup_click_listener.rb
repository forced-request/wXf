#!/usr/bin/env ruby

require 'java'

java_import javax.swing.JMenuItem
java_import javax.swing.JPopupMenu
java_import java.awt.event.MouseAdapter

module WxfGui
class PopUpItem < JPopupMenu

  
  def initialize(tree)
    super()
    @tree = tree
    send_to_console_item = JMenuItem.new("send to console")
    send_to_console_item.addMouseListener(SelectModuleListener.new(send_to_console_item))
    view_description_item = JMenuItem.new("view module description")
    view_description_item.addMouseListener(SelectModuleListener.new(view_description_item))
    self.add(send_to_console_item)
    self.add(view_description_item)
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

class SelectModuleListener < MouseAdapter
  
  def initialize(menu_item)
    @menu_item = menu_item
    super()
  end
  
  def mousePressed(event)
    if @menu_item.text == "send to console"
      panel = JPanel.new
    elsif @menu_item.text == "view module description"
     # Do stuff here
    end 
  end
  
  def mouseReleased(event)
  end
  
  def test_popup(event)
  end
  
end

class ModulesPopUpClickListener < MouseAdapter
  
  def initialize(tree)
    super()
    @pop_up = PopUpItem.new(tree)
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
