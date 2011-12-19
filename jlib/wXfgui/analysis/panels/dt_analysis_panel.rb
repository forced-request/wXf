require 'java'
require 'wXfgui/main/popup_menus/expand_collapse'

import javax.swing.tree.DefaultMutableTreeNode

module WxfGui
  
  class DtAnalysisPanel < JPanel
    include MouseListener
    include WxfGui::ExpandCollapse
    
    def initialize(wXfgui)
      @wXfgui = wXfgui
      super()
      init
    end
  
    def init
      
      @dt_tree_listener = DtTreeModelListener.new
      @dt_tree = DtTree.new(@wXfgui.base.selected_dt_items)
      @dt_tree.addTreeModelListener(@dt_tree_listener)
      @dt_jtree = JTree.new(@dt_tree)
      
      @dt_table_panel = DtTablePanel.new
    
      @t_scroll_pane_1 = JScrollPane.new(@dt_jtree)
      
      @dt_tabs = DtTabs.new
           
      split_pane1 = JSplitPane.new JSplitPane::VERTICAL_SPLIT
      split_pane1.setDividerLocation 325
      split_pane1.add @dt_table_panel
      split_pane1.add @dt_tabs
        
      
      split_pane2 = JSplitPane.new JSplitPane::HORIZONTAL_SPLIT
      split_pane2.setDividerLocation 300
      split_pane2.add @t_scroll_pane_1
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
  
    def refresh
       @dt_jtree.updateUI()
    end 
     
    def load_dt_tree
      refresh
      expand_all(@dt_jtree)
    end  
  
    def unload_dt_tree
      refresh
      collapse_all(@dt_jtree)
    end
  
  end
end