#!/usr/bin/env jruby

require 'java'
require 'wXfgui/database'

module WxfGui 
module BaseController
 
  include WxfGui::DecisionTreeDatabaseManager
  
  attr_accessor :module_stack, :decision_tree_stack, :selected_dt_items, :in_focus
  
  def initialize
    self.module_stack = []
    self.decision_tree_stack = []
    self.selected_dt_items = {}
    self.in_focus = []
  end
  
  def add_module_activity(activity)
  end
  
  def remove_module_activity
  end
  
  def remove_module_activity_by_name(activity_name)
  end
  
  def add_decision_tree_activity(activity)
    self.in_focus.push(activity)
  end

  def remove_decision_tree_activity
    self.in_focus.pop
  end
  
  def remove_decision_tree_activity_by_name(activity_name)
  end
  
  def add_all_selected_dt(hsh)
    return unless hsh != nil
    if hsh.kind_of?(Hash)
      hsh.each do |k, row|
        nrow = []
        row.each do |dt|
          nrow.push(dt)
        end
        self.selected_dt_items["#{k}"] = nrow
      end
    end 
  end
  
  def remove_all_selected_dt
    self.selected_dt_items.clear
  end
  
  def db_insert_focused_dt
    mod = in_focus.last
    idx = in_focus.index(mod)
    insert_focused_dt(in_focus.last, idx)
  end

end end