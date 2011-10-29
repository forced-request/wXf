#!/usr/bin/env jruby

import javax.swing.JFrame
import javax.swing.JOptionPane

module WxfGui
class Notifications < JFrame

   def initialize(notif, text=nil)
    @notif = notif || 'Generic Error'
    @text = text || 'General Error'
    super("#{@notif}")    
    init
   end

   def init
      JOptionPane.showMessageDialog self, "#{@text}",
       "Error", JOptionPane::ERROR_MESSAGE
   end

end
end 