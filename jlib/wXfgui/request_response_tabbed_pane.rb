#!/usr/bin/env jruby

require 'wXfgui/request_response_list'

java_import javax.swing.JSplitPane
java_import javax.swing.JTabbedPane
java_import javax.swing.JScrollPane
java_import javax.swing.JTextPane


module WxfGui
class RequestResponseTabbedPane< JTabbedPane

    
  def initialize    
    super(JTabbedPane::TOP, JTabbedPane::SCROLL_TAB_LAYOUT)
    @response = JTextPane.new()
    @request  = JTextPane.new()
    @response.editable = false
    @request.editable = false
    @text_pane_req  = JScrollPane.new(@request)
    @text_pane_resp = JScrollPane.new(@response)
    add("Request", @text_pane_req)
    add("Response", @text_pane_resp)
    listener
  end
  
  def add(*vals)
    name, obj = vals
    self.add_tab(name, obj)
  end
  
  def listener(*params)
    self.add_change_listener do |event|
    #=begin
    #THIS IS ALL STUBBED CODE, USING IT AS AN EXAMPLE.
      if self.selected_component == @text_pane_resp
        d = ""
        exec = IO::popen(@request.text, "r")
        exec.each {|data|
          d << "#{data}"
        }
      exec.close
      @response.text = d
      end
    end
    #=end 
  end
  
end

end
