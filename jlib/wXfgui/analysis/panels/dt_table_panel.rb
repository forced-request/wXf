require 'java'

import javax.swing.JPanel
import javax.swing.JTable
import java.awt.Color

module WxfGui
  
  class DtTablePanel < JPanel
    
    def initialize(wXfgui)
      @wXfgui = wXfgui
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
      @analyze_button  = JButton.new("analyze")
      
      @next_button.add_action_listener do |e|
        n_item = @wXfgui.base.next_item
        @wXfgui.base.add_decision_tree_activity(n_item)
        @wXfgui.repaint()
      end
      
      @analyze_button.add_action_listener do |e|
      
      end
      
      p1.addComponent(@next_button)
      p1.addComponent(@analyze_button)
      sh1.addComponent(@js1)
      sh1.addGroup(p1)
      
      sv2.addComponent(@js1)
      sv3.addComponent(@next_button)
      sv3.addComponent(@analyze_button)
      p2.addGroup(sv2)
      p2.addGroup(sv3)
      sv1.addGroup(p2)
      
      layout.linkSize SwingConstants::HORIZONTAL, 
          @next_button, @analyze_button
      
  end

  
    
  end
end
