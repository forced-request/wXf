require 'java'

import javax.swing.JPanel
import javax.swing.JTable
import java.awt.Color

module WxfGui
  
  class DtTablePanel < JPanel
    
    def initialize(wXfgui, dt_analysis_panel)
      @wXfgui = wXfgui
      @dt_analysis_panel = dt_analysis_panel
      super()
      init
    end
    
    def init
      
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
      sv2 = layout.createSequentialGroup
      sv3 = layout.createSequentialGroup
      p1  = layout.createParallelGroup
      p2 = layout.createParallelGroup
      
      layout.setHorizontalGroup sh1
      layout.setVerticalGroup sv1
    
      
      @dat = DtAnalysisTable.new
      @dat_jtable = JTable.new(@dat)
      @dat_jtable.show_vertical_lines = true
      @dat_jtable.show_grid = true
      @dat_jtable.grid_color = Color.lightGray
     
      
      @js1 = JScrollPane.new(@dat_jtable)
      
      @next_button  = JButton.new("next")
      @next_button.enabled = false
      @analyze_button  = JButton.new("analyze")
      @run_mod_button  = JButton.new("run module")
      
      @next_button.add_action_listener do |e|
        n_item = @wXfgui.base.next_item
        if n_item != nil 
          @wXfgui.base.add_decision_tree_activity(n_item)
          @wXfgui.base.db_insert_focused_dt
          update
          disable_next_button
          @dt_analysis_panel.clear
          @dt_analysis_panel.load_details
        else
          disable_next_button
          disable_analyze_button
        end
      
        @wXfgui.repaint()
      end
      
      @analyze_button.add_action_listener do |e|
        @dt_analysis_panel.load_info
        enable_next_button       
      end
      
      @run_mod_button.add_action_listener do |e|
        
      end
      
      p1.addComponent(@next_button)
      p1.addComponent(@run_mod_button)
      p1.addComponent(@analyze_button)
      sh1.addComponent(@js1)
      sh1.addGroup(p1)
      
      sv2.addComponent(@js1)
      sv3.addComponent(@next_button)
      sv3.addComponent(@run_mod_button)
      sv3.addComponent(@analyze_button)
    
      p2.addGroup(sv2)
      p2.addGroup(sv3)
      sv1.addGroup(p2)
      
      layout.linkSize SwingConstants::HORIZONTAL, 
          @next_button, @analyze_button, @run_mod_button
      
    end
    
    def update
      @dat.update_row
    end
    
    def reset
      @dat.reset
    end
    
    def disable_next_button
      @next_button.enabled = false
    end
    
    def enable_next_button
      @next_button.enabled = true
    end
    
    def disable_analyze_button
      @analyze_button.enabled = false
    end
    
    def enable_analyze_button
      @analyze_button.enabled = true
    end
    
     def disable_run_mod_button
      @run_mod_button.enabled = false
    end
    
    def enable_run_mod_button
      @run_mod_button.enabled = true
    end
    
  end
end
