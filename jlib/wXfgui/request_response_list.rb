#!/usr/bin/env jruby

java_import javax.swing.JList
java_import javax.swing.JTextPane
java_import javax.swing.DefaultListModel
java_import javax.swing.ListSelectionModel


module WxfGui
class RequestResponseList < JList
  
  def initialize
    @text_pane = JTextPane.new
    super(DefaultListModel.new)
    self.selection_mode = ListSelectionModel::SINGLE_SELECTION
    listener
  end
  
  def listener
     contents = Hash.new('')
      self.add_list_selection_listener do |e|
        unless e.value_is_adjusting
        new_index = e.source.get_selected_index
        old_index = [e.first_index, e.last_index].find {|i| i !=new_index}
    
        contents[old_index] = contents[new_index]
      end
    end
  end
  
end
end