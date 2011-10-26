#!/usr/bin/env jruby

require 'java'
require 'wXfgui/burp_handler'

import java.awt.Dimension
import javax.swing.GroupLayout
import javax.swing.JFrame
import javax.swing.JButton
import javax.swing.JPanel
import javax.swing.JFileChooser
import javax.swing.JTextField
import javax.swing.JScrollPane
import javax.swing.filechooser::FileNameExtensionFilter

module WxfGui
class BurpFileChooser < JFrame
  
    def initialize
        super "Open and Start Burp"
        
        self.initUI
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
      text_pane.editable = false
      text_pane.setSize 500,30
      j_panel.add(text_pane)
      
      open_button = JButton.new "Choose file"
        open_button.addActionListener do |e|
            chooseFile = JFileChooser.new
            filter = FileNameExtensionFilter.new "jar files", "jar"
            chooseFile.addChoosableFileFilter filter

            ret = chooseFile.showDialog @panel, "Choose file"

            if ret == JFileChooser::APPROVE_OPTION
                file = chooseFile.getSelectedFile
                file_name = self.readFile(file)
                text_pane.text = file_name
                
                # Time to start rocking burp :-)                
                begin
                  burp = BurpHandler.new(file_name, self)
                rescue LoadError
                    JOptionPane.showMessageDialog self, "Could not open Burp",
                    "Error", JOptionPane::ERROR_MESSAGE
                end            
            end
        end
        
        cancel_button = JButton.new "Cancel"        
        cancel_button.addActionListener do |e|
          self.dispose()
        end
        
        sh1 = layout.createSequentialGroup
        sv1 = layout.createSequentialGroup
        p1 = layout.createParallelGroup
        p2 = layout.createParallelGroup
      
        layout.setHorizontalGroup sh1
        layout.setVerticalGroup sv1
      
        p1.addComponent j_panel
        p1.addComponent cancel_button
        sh1.addGroup p1
        sh1.addComponent open_button
        
        
        sv1.addComponent j_panel
        p2.addComponent cancel_button
        p2.addComponent  open_button
        sv1.addGroup p2

        self.setSize 400, 125
        self.setLocationRelativeTo nil
        self.setVisible true
    end
    
    def readFile(file)        
        filename = file.getCanonicalPath
        return filename
    end    
  end
end 