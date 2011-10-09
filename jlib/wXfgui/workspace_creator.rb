#!/usr/bin/env jruby

require 'java'
require 'wXfgui/database_manager'


import java.awt.Dimension
import javax.swing.GroupLayout
import javax.swing.JFrame
import javax.swing.JButton
import javax.swing.JPanel
import javax.swing.JFileChooser
import javax.swing.JOptionPane
import javax.swing.JTextField
import javax.swing.JScrollPane
import javax.swing.filechooser::FileNameExtensionFilter

module WxfGui
class WorkspaceCreator < JFrame
  
    def initialize(wXfgui)
        super "Enter Workspace Name"        
        self.initUI
        @wXfgui = wXfgui
    end
      
    def initUI
      
        layout = GroupLayout.new self.getContentPane
        # Add Group Layout to the frame
        self.getContentPane.setLayout layout
        # Create sensible gaps in components (like buttons)
        layout.setAutoCreateGaps true
        layout.setAutoCreateContainerGaps true
        
        j_panel = JPanel.new
        j_panel.setLayout nil
        
        text_pane = JTextField.new
        text_pane.editable = true
        text_pane.setSize 500,30
        j_panel.add(text_pane)
      
        open_button = JButton.new "Save"
        open_button.addActionListener do |e|
            if not text_pane.text.empty?
               new_text = text_pane.text.to_s
               new_text.gsub!('.db', '')
               dm = DatabaseManager.new(new_text)
               dm.init_db
               @wXfgui.restore
               dispose()
            else
                JOptionPane.showMessageDialog self, "Please enter a workspace name",
                    "Error", JOptionPane::ERROR_MESSAGE
            end 
        end  

        sh1 = layout.createSequentialGroup
        sv1 = layout.createSequentialGroup
        p1 = layout.createParallelGroup
        p2 = layout.createParallelGroup
      
        layout.setHorizontalGroup sh1
        layout.setVerticalGroup sv1
      
        p1.addComponent j_panel
        sh1.addGroup p1
        sh1.addComponent open_button
        
        
        sv1.addComponent j_panel
        p2.addComponent  open_button
        sv1.addGroup p2

        self.setSize 400, 100
        self.setLocationRelativeTo nil
        self.setVisible true
        self.setDefaultCloseOperation JFrame::EXIT_ON_CLOSE
    end
     
end
end