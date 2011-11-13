#!/usr/bin/env ruby

require 'java'

java_import javax.swing.JMenuItem
java_import javax.swing.JPopupMenu
java_import java.awt.event.MouseAdapter

module WxfGui
class ModPopUpItem < JPopupMenu

  
  def initialize(tree, wXfgui)
    super()
    @tree = tree
    @wXfgui = wXfgui
    send_to_console_item = JMenuItem.new("send to console")
    send_to_console_item.addMouseListener(ModSelectModuleListener.new(send_to_console_item, @wXfgui))
    view_description_item = JMenuItem.new("view module description")
    view_description_item.addMouseListener(ModSelectModuleListener.new(view_description_item, @wXfgui))
    self.add(send_to_console_item)
    self.add(view_description_item)
  end
  
  
  #
  # Note: show_it and normalize_path aren't utilizing jtree's methods
  # ...to handle this more elegantly. The expand all function is a good example :-)
  #
  
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

class DtModPopUpItem < JPopupMenu

  
  def initialize(tree)
    super()
    @tree = tree
    expand_all = JMenuItem.new("expand all")
    expand_all.addMouseListener(DtModSelectModuleListener.new(expand_all, tree))
    collapse_all = JMenuItem.new("collapse all")
    collapse_all.addMouseListener(DtModSelectModuleListener.new(collapse_all, tree))
    self.add(expand_all)
    self.add(collapse_all)
  end
  
  
  #
  # Note: show_it and normalize_path aren't utilizing jtree's methods
  # ...to handle this more elegantly. The expand all function is a good example :-)
  #
  
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



#
# Class to do something with the pop items from module
#
class ModSelectModuleListener < MouseAdapter
  
  def initialize(menu_item, wXfgui)
    @wXfgui = wXfgui
    @menu_item = menu_item
    super()
  end
  
  def mousePressed(event)
    if @menu_item.text == "send to console"
      # We can access the send to console function now
    elsif @menu_item.text == "view module description"
     # Stub
    end 
  end
  
  def mouseReleased(event)
  end
  
  def test_popup(event)
  end
  
end

#
# Class to do something with the pop items from module
#
class DtModSelectModuleListener < MouseAdapter
  
  def initialize(menu_item, tree)
    @tree = tree
    @menu_item = menu_item
    super()
  end
  
  def mousePressed(event)
    if @menu_item.text == "expand all"
      # We can access the send to console function now
    elsif @menu_item.text == "collapse all"
     # Stub
    end 
  end
  
  def mouseReleased(event)
  end
  
  def test_popup(event)
  end
  
end




class ModulesPopUpClickListener < MouseAdapter
  
  def initialize(tree, wXfgui=nil)
    super()
    @wXfgui = wXfgui
    @root = tree.getModel().getRoot()
    case @root
    when "Modules"  
      @pop_up = ModPopUpItem.new(tree, @wXfgui)
    when "Decision Tree"
      @pop_up = DtModPopUpItem.new(tree)
    end
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
    if @root and @pop_up.respond_to?('show_it')
      @pop_up.show_it(event)
    end 
  end
  
end

end
