require 'java'

import javax.swing.JTabbedPane

module WxfGui
  
  class DtTabs < JTabbedPane
    
    def initialize 
      super(JTabbedPane::TOP, JTabbedPane::SCROLL_TAB_LAYOUT)
      add_tabs 
    end
    
    def add_tabs
      @details  =   DetailsPanel.new()
      @info  = InfoPanel.new()
      add("Module Details", @details)
      add("Information", @info)
    end
    
  end

end