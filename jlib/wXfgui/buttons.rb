#!/usr/bin/env jruby

require 'wXfgui/burp_handler'

import javax.swing.JButton



# Class to handle button actions and what not
# ...trying to seperate things out a bit. Makes more
# ...sense visually.
#
module WxfGui
class Buttons < JButton
  
  def initialize(name)
    @name = name
    super
  end
  
  
  #
  # Decide which listener to send which click to
  # 
  def listener    
    case @name
    when "Quit"
      quitListener
    when "Start Burp"
      burpStartListener
    when "Stop Burp"
      burpStopListener
    end
  end


  #
  # If we want to quit, ensure we close :-)
  #
  def quitListener
    self.add_action_listener do |event|
       java.lang.System.exit 0
    end
  end

  #TODO: REMOVE HARDCODED BURP LOCATION
  def burpStartListener
    self.add_action_listener do |event|
       $burp = BurpHandler.new("/Users/cktricky/Desktop/burp/burp.jar")
       $burp.start
    end
  end
  
   
  #
  # This is an action which will stop Burp cold in its track.
  # Only problem is, it will close out our entire app. No bueno mi amigos.
  #
  def burpStopListener
    self.add_action_listener do |event|
       #if  
         $burp.stop
       #end
    end
  end



end

end