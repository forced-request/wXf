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
    @advisories = JTextPane.new()
    @general  = GeneralPanel.new()
    @console  = JTextPane.new()
    @scope  =   ScopePanel.new()
    @advisories.editable = false
    @console.editable = false
    @text_pane_advisories  = JScrollPane.new(@advisories)
    @general_panel = JScrollPane.new(@general)
    @text_pane_console  = JScrollPane.new(@console)
    @panel_scope  = JScrollPane.new(@scope)
    add("Advisories",  @text_pane_advisories)
    add("General", @general_panel)
    add("Console", @text_pane_console)
    add("Scope", @panel_scope)
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
    @general.restore
  end
  
  def send_general_text(*params)
    @general.add_text(*params)
  end
   
   
end
end 
