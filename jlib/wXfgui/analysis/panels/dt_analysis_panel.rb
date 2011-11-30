module WxfGui
  
  class DtAnalysisPanel < JPanel
    include MouseListener
  
    def initialize
      super()
      init
    end
  
    def init
#=begin     
      t_scroll_pane_1 = JPanel.new#JScrollPane.new(#PUT SOMETHING HERE)
      t_scroll_pane_2 = JPanel.new# PUT A PANEL HERE
      
           
      split_pane1 = JSplitPane.new JSplitPane::VERTICAL_SPLIT
      split_pane1.setDividerLocation 390
      split_pane1.add JPanel.new# Put a panel here
      split_pane1.add JPanel.new# Put a panel here
        
      
      split_pane2 = JSplitPane.new JSplitPane::HORIZONTAL_SPLIT
      split_pane2.setDividerLocation 300
      split_pane2.add JPanel.new# Panel here
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
#=end      
    end
  end
end