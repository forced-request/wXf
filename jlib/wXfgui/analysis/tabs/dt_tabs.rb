require 'java'

import javax.swing.JTabbedPane

module WxfGui
  
  class DtTabs < JTabbedPane
    
    def initialize(wXfgui)
      @wXfgui = wXfgui
      super(JTabbedPane::TOP, JTabbedPane::SCROLL_TAB_LAYOUT)
      add_tabs 
    end
    
    def add_tabs
      @details  =   DetailsPanel.new(@wXfgui)
      @info  = InfoPanel.new(@wXfgui)
      add("Module Details", @details)
      add("Analysis Info", @info)
    end
    
    def load_details
      @details.load_details
    end
    
    def load_info
      @info.load_info
    end
    
    def clear
      @details.clear_details
      @info.clear_info
    end
    
  end

end