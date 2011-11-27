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
  
  def initialize
     super(JTabbedPane::TOP, JTabbedPane::SCROLL_TAB_LAYOUT)
     initUI
  end
  
  def initUI
     
     self.add("Decision Tree", scp)
     #self.add("Results Analysis" rap)
  end
  
end

end