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
    self.initUI
    @wXfgui = wXfgui
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
    
    @wXfexit = JMenuItem.new "exit"      
    @wXfexit.setMnemonic KeyEvent::VK_E
    @wXfexit.addActionListener do |e|
      @wXfgui.close_it
    end
    
    self.add(@wXfrestore)
    self.add(@wXfstart)
    self.add(@wXfexit)
  end
  
  def disable(name)
    case name
    when "all"
      @wXfrestore.enabled = false
      @wXfstart.enabled = false
      @wXfexit.enabled = false
    when "restore workspace"
      @wXfrestore.enabled = false
    when "start decision tree"
      @wXfstart.enabled = false
    when "exit"
       @wXfexit.enabled = false
    end
  end
  
   def enable(name)
    case name
    when "all"
      @wXfrestore.enabled = true
      @wXfstart.enabled = true
      @wXfexit.enabled = true
    when "restore workspace"
      @wXfrestore.enabled = true
    when "start decision tree"
      @wXfstart.enabled = true
    when "exit"
      @wXfexit.enabled = true
    end
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