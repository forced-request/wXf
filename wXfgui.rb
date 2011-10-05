#!/usr/bin/env jruby

wXfbase = File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__
WXFDIR = File.join(File.expand_path(File.dirname(wXfbase)))
$:.unshift(File.join(File.expand_path(File.dirname(wXfbase)), 'jlib'))


#System level requirements
require 'java'
require 'rubygems'

#wXf gui elements
require 'wXfgui/request_response_tabbed_pane'
require 'wXfgui/wxfgui_menu'
require 'wXfgui/modules_tree'
require 'wXfgui/mod_loader'
require 'wXfgui/popup_click_listener'
require 'wXfgui/request_response_tabbed_pane'
require 'wXfgui/main_tabs'
require 'wXfgui/checkbox_rendering'
require 'wXfgui/decision_tree'

# Time to require native wXf stuff
require 'wXf/wXfassists'
require 'wXf/wXfconductors'
require 'wXf/wXfconstants'
require 'wXf/wXflog'
require 'wXf/wXfmod_factory'
require 'wXf/wXfui'
require 'wXf/wXfwebserver'


# Necessary libs, well, most of them......
import java.util.LinkedList
import java.util.Properties
import javax.swing.JTree
import javax.swing.tree.DefaultMutableTreeNode
import javax.swing.tree.TreeModel
import java.awt.Dimension
import java.awt.Color
import java.awt.Font
import javax.swing.BorderFactory
import javax.swing.SwingConstants
import javax.swing.JFrame
import javax.swing.JLabel
import javax.swing.JTextArea
import javax.swing.JComponent
import javax.swing.JList
import javax.swing.JPanel
import javax.swing.JMenuBar
import javax.swing.JScrollPane
import javax.swing.JTabbedPane
import javax.swing.GroupLayout
import java.awt.event.MouseListener
import java.awt.event.FocusListener
import java.awt.event.MouseEvent

module WxfGui
class WxfGuiTabbedPane < JTabbedPane
    
  def initialize
    super(JTabbedPane::TOP, JTabbedPane::SCROLL_TAB_LAYOUT)
    wXf_cc_panel = WxfMainPanel.new
    wXf_module_panel = WxfModulePanel.new    
    add("Main", wXf_cc_panel)
    add("Buby", wXf_module_panel)
    listener
  end
  
  def add(*vals)
    name, obj = vals
    self.add_tab(name, obj)
  end
  
  def listener(*params)
    self.add_change_listener do |event|
    #=begin
    #THIS IS ALL STUBBED CODE, USING IT AS AN EXAMPLE.
  
    end
    #=end 
  end
end


#
#
# This is going to be a class that we use to institute a console interface
#
#
class WxfModulePanel < JPanel
  
   include MouseListener
   include FocusListener
  
  def initialize
    super
  end
  
end

class WxfMainPanel < JPanel
  
   include MouseListener
  
  def initialize
    super
    init
  end
  
  def init

=begin    
      #
      # Templated Request/Response Tabbed Panes
      #
      
      rrtp = RequestResponseTabbedPane.new

      scroll_list  = RequestResponseList.new
      scroll_checklist = JScrollPane.new(scroll_list)
=end

      main_tabs = MainTabs.new
      
      
      #
      # SCROLL PANE
      #
      
      treeModel = ModulesTree.new(ModLoader.new)
    
      tree_1 = JTree.new(treeModel)
      tree_1.shows_root_handles = true
      tree_1.addMouseListener(ModulesPopUpClickListener.new(tree_1))
      t_scroll_pane_1 = JScrollPane.new(tree_1)
      
      
      dtm = DecisionTreeFactory.new
      dtm_modules = dtm.module_hash
      decisionTreeModel = DecisionTreeModel.new(dtm_modules)   
      
      tree_2 = JTree.new(decisionTreeModel)
      renderer = CheckBoxNodeRenderer.new
      tree_2.set_cell_renderer(renderer)    
      tree_2.cell_editor = CheckBoxNodeEditor.new(tree_2, renderer)
      tree_2.editable = true
      tree_2.shows_root_handles = true
      t_scroll_pane_2 = JScrollPane.new(tree_2)
             
               
      
      #
      # SPLIT PANES  
      #
      
           
      split_pane1 = JSplitPane.new JSplitPane::VERTICAL_SPLIT
      split_pane1.setDividerLocation 390
      split_pane1.add t_scroll_pane_2
      split_pane1.add main_tabs
        
      
      split_pane2 = JSplitPane.new JSplitPane::HORIZONTAL_SPLIT
      split_pane2.setDividerLocation 300
      split_pane2.add t_scroll_pane_1
      split_pane2.add split_pane1
      
       
      
      
      
      #
      # GROUP LAYOUT OPTIONS
      #
      
      layout = GroupLayout.new self
      # Add Group Layout to the frame
      self.setLayout layout
      # Create sensible gaps in components (like buttons)
      layout.setAutoCreateGaps true
      layout.setAutoCreateContainerGaps true
    
      sh1 = layout.createSequentialGroup
      sv1 = layout.createSequentialGroup
      p1 = layout.createParallelGroup
      p2 = layout.createParallelGroup
      
      layout.setHorizontalGroup sh1
      layout.setVerticalGroup sv1
    
      sh1.addComponent split_pane2
      sh1.addGroup p1
       
      p2.addComponent split_pane2
      sv1.addGroup p2
      
  end
end

class Wxfgui < JFrame
  
  def initialize
      super "The Web Exploitation Framework"      
      self.initUI
  end
    
  def initUI
      
      @wXf_gui_tabbed_pane = WxfGuiTabbedPane.new
      self.add @wXf_gui_tabbed_pane
      
      #
      # MENU BAR
      #
      
      menuBar = JMenuBar.new
      menuBar.add WxfMenu.new
      menuBar.add BubyMenu.new
      menuBar.add AboutMenu.new
            
      #
      # FRAME OPTIONS
      #
      
      # Set the overall side of the frame
      self.setJMenuBar menuBar
      self.setPreferredSize Dimension.new 1300, 900
      self.pack
    
      self.setDefaultCloseOperation JFrame::EXIT_ON_CLOSE
      self.setLocationRelativeTo nil
      self.setVisible true
  end
  
end

end

WxfGui::Wxfgui.new
