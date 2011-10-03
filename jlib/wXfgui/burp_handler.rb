#!/usr/bin/env jruby

require 'rubygems'
require 'buby'

java_import javax.swing.JOptionPane

module WxfGui
class BurpHandler
  
  def initialize(burp, frame)
      burp_string = burp.to_s
      if File.exists?(burp_string)
        burp_is_present =  Buby.load_burp(burp_string)
        if burp_is_present == true 
          $burp = Buby.new()
          frame.dispose()
        else
          raise LoadError
        end 
      end
      start
  end
  
  def start
      if $burp
        $burp.start_burp()
      end
  end
  
  def stop
    if $burp 
      $burp.close(true)
    end
  end
  
end

end