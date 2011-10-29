import javax.swing.JPanel
import java.awt.event.FocusListener
import java.awt.event.MouseListener

#
#
# This is going to be an analysis tab where the decision tree works its magic
#
#
module WxfGui
class WxfAnalysisPanel < JPanel
  
   include MouseListener
   include FocusListener
  
  def initialize
    super
  end
  
end

end