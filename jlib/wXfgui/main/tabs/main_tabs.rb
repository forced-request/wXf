#!/usr/bin/env jruby

java_import javax.swing.JSplitPane
java_import javax.swing.JTabbedPane
java_import javax.swing.JScrollPane
java_import javax.swing.JTextPane

module WxfGui
class MainTabs < JTabbedPane

    
  def initialize    
    super(JTabbedPane::TOP, JTabbedPane::SCROLL_TAB_LAYOUT)
    add_tabs
    listener
  end
  
  def add(*vals)
    name, obj = vals
    self.add_tab(name, obj)
  end
  
  def add_tabs
    @log  = LogPanel.new()
    @scope  =   ScopePanel.new()
    @panel_scope  = JScrollPane.new(@scope)
    add("Scope", @panel_scope)
    add("Log", @log)
  end
  
  def listener(*params)
    self.add_change_listener do |event|
=begin
    #THIS IS ALL STUBBED CODE, USING IT AS AN EXAMPLE
=end

    end
  end
  
  def restore
    @scope.restore
    @log.restore
  end
  
  def send_log_text(*params)
    @log.add_text(*params)
  end 
   
end
end 
