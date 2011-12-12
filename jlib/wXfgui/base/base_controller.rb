#!/usr/bin/env jruby

require 'java'
require 'wXfgui/database'

module WxfGui 
module BaseController
 
  include WxfGui::DecisionTreeDatabaseManager
  
  attr_accessor :module_stack, :decision_tree_stack, :selected_dt_items
  
  def initialize
    self.module_stack = []
    self.decision_tree_stack = []
    self.selected_dt_items = []
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
    self.selected_dt_items.each {|x| puts x.respond_to?('start')}
  end
  
  def remove_all_selected_dt
    self.selected_dt_items.clear
    delete_decision_tree_stack
  end

end end