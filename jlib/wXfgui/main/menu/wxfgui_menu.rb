#!/usr/bin/env jruby

require 'find'
#require 'wXfgui/burp_file_chooser'

import java.awt.event.ActionEvent
import java.awt.event.KeyEvent
import javax.swing.KeyStroke
import javax.swing.JMenu
import javax.swing.JMenuItem
import javax.swing.SwingWorker

module WxfGui
class WxfMenu < JMenu
  
  def initialize(wXfgui)
    super("wXf")
    @wXfgui = wXfgui
    self.initUI
  end

  def initUI
    
    @wXfrestore = JMenuItem.new "restore workspace"
    @wXfrestore.setMnemonic KeyEvent::VK_R
    @wXfrestore.addActionListener do |e|
      @wXfgui.check_workspace
    end
    
    @wXfstart = JMenuItem.new "start decision tree"      
    @wXfstart.setMnemonic KeyEvent::VK_C
    @wXfstart.addActionListener do |e|
      @wXfgui.start_dt
    end
    
    @wXfstop = JMenuItem.new "stop decision tree"      
    @wXfstop.setMnemonic KeyEvent::VK_C
    @wXfstop.addActionListener do |e|
      @wXfgui.stop_dt
    end
    disable("stop decision tree")
    
    @wXfexit = JMenuItem.new "exit"      
    @wXfexit.setMnemonic KeyEvent::VK_E
    @wXfexit.addActionListener do |e|
      @wXfgui.close_it
    end
    
    self.add(@wXfrestore)
    self.add(@wXfstart)
    self.add(@wXfstop)
    self.add(@wXfexit)
  end
  
  def disable(name)
    case name
    when "all"
      @wXfrestore.enabled = false
      @wXfstart.enabled = false
      @wXfstop.enabled = false
      @wXfexit.enabled = false
    when "restore workspace"
      @wXfrestore.enabled = false
    when "start decision tree"
      @wXfstart.enabled = false
    when "stop decision tree"
      @wXfstop.enabled = false
    when "exit"
       @wXfexit.enabled = false
    end
  end
  
   def enable(name)
    case name
    when "all"
      @wXfrestore.enabled = true
      @wXfstart.enabled = true
      @wXfstop.enabled = true
      @wXfexit.enabled = true
    when "restore workspace"
      @wXfrestore.enabled = true
    when "start decision tree"
      @wXfstart.enabled = true
    when "stop decision tree"
      @wXfstop.enabled = true
    when "exit"
      @wXfexit.enabled = true
    end
  end
  

end

class XmlRpcMenu < JMenu
  
  def initialize(wXfgui)
    super "xmlrpc"
    @wXfgui = wXfgui
    self.initUI
  end

  def initUI

    @xmlrpc_connect = JMenuItem.new "connect xmlrpc"      
    @xmlrpc_connect.setMnemonic KeyEvent::VK_C
    @xmlrpc_connect.addActionListener do |e|
      #stub
    end
    
    @xmlrpc_disconnect = JMenuItem.new "disconnect xmlrpc"      
    @xmlrpc_disconnect.setMnemonic KeyEvent::VK_C
    @xmlrpc_disconnect.addActionListener do |e|
      #stub
    end
    
    self.add(@xmlrpc_connect)
    self.add(@xmlrpc_disconnect)
  end  
  
end

class BubyMenu < JMenu
  
  def initialize
    super "buby"
    self.initUI
  end

  def initUI
    burpOpen = JMenuItem.new "open burp"
    burpOpen.setMnemonic KeyEvent::VK_O
    burpOpen.addActionListener do |e|        
      b_file_frame = BurpFileChooser.new
    end
    
    burpTest = JMenuItem.new "test connection"
    burpTest.setMnemonic KeyEvent::VK_T
    burpTest.addActionListener do |e|        
     puts "test not yet implmemented"
    end
    
    burpRun = JMenuItem.new "run selected modules"
    burpRun.setMnemonic KeyEvent::VK_R
    burpRun.addActionListener do |e|        
     puts "run not yet implmemented"
    end
    
    self.add(burpOpen)
    self.add(burpTest)
    self.add(burpRun)
  end

end

class AboutMenu < JMenu
  
  def initialize
    super "about"
    self.initUI
  end

  def initUI
    
    version = JMenuItem.new "version"      
    version.setMnemonic KeyEvent::VK_V
    version.addActionListener do |e|
      puts "version not yet implemented"
    end
    
    license = JMenuItem.new "license"      
    license.setMnemonic KeyEvent::VK_L
    license.addActionListener do |e|
      puts "license not yet implemented"
    end
  
    self.add(version)
    self.add(license)
  end

end

end