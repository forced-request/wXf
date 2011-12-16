#!/usr/bin/env jruby

require 'java'
require 'wXfgui/database'

module WxfGui 
module BaseController
 
  include WxfGui::DecisionTreeDatabaseManager
  
  attr_accessor :module_stack, :decision_tree_stack, :selected_dt_items, :dtmn
  
  def initialize
    self.module_stack = []
    self.decision_tree_stack = []
    self.selected_dt_items = []
    self.dtmn = []
  end
  
  def add_module_activity(activity)
  end
  
  def remove_module_activity
  end
  
  def remove_module_activity_by_name(activity_name)
  end
  
  def add_decision_tree_activity(activity)
  end

  def remove_decision_tree_activity
  end
  
  def remove_decision_tree_activity_by_name(activity_name)
  end
  
  def add_all_selected_dt(arry)
    return unless arry != nil
    if arry.kind_of?(Array)
      self.selected_dt_items.concat(arry)
       insert_decision_tree_stack(arry)
    end
  end
  
  def remove_all_selected_dt
    self.selected_dt_items.clear
    # DatabaseManager Method
    delete_decision_tree_stack
  end
  
  def add_default_mutable_nodes(node)
    self.dtmn.push(node)
  end
  
  def remove_all_default_mutable_nodes
    self.dtmn.clear
  end

end end