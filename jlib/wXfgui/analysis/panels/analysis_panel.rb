require 'java'

import javax.swing.JPanel
import java.awt.event.FocusListener
import java.awt.event.MouseListener
import javax.swing.JTabbedPane


#
# This is where analysis + decision tree items work their magic
#


module WxfGui
class WxfAnalysisPanel < JTabbedPane
  
  def initialize(wXfgui)
     @wXfgui = wXfgui
     super(JTabbedPane::TOP, JTabbedPane::SCROLL_TAB_LAYOUT)
     initUI
  end
  
  def initUI
     
     #Instantiate
     @dap = DtAnalysisPanel.new(@wXfgui)
    
     # Add the instantiated objs
     self.add("Decision Tree", @dap)
     #self.add("Results Analysis" rap)
     
  end
  
  def load_dt_tree
    @dap.load_dt_tree
  end
  
  def unload_dt_tree
    @dap.unload_dt_tree
  end
  
end

end