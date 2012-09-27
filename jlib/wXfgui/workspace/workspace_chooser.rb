#!/usr/bin/env jruby

require 'java'
require 'find'


import java.awt.Dimension
import javax.swing.GroupLayout
import javax.swing.GroupLayout::Alignment
import javax.swing.JFrame
import javax.swing.JButton
import javax.swing.JPanel
import javax.swing.JFileChooser
import javax.swing.JOptionPane
import javax.swing.JTextField
import javax.swing.JScrollPane
import javax.swing.filechooser::FileNameExtensionFilter

module WxfGui
class WorkspaceChooser < JFrame
  
    def initialize(wXfgui)
        @wXfgui = wXfgui
        super("Choose your workspace")        
        self.initUI
       
    end
      
    def initUI
      
        layout = GroupLayout.new self.getContentPane
        # Add Group Layout to the frame
        self.getContentPane.setLayout layout
        # Create sensible gaps in components (like buttons)
        layout.setAutoCreateGaps true
        layout.setAutoCreateContainerGaps true

        sh1 = layout.createSequentialGroup
        sv1 = layout.createSequentialGroup
        p1 = layout.createParallelGroup
        p2 = layout.createParallelGroup
      
        layout.setHorizontalGroup sh1
        layout.setVerticalGroup sv1
        
        create_checkbox = JCheckBox.new("Create New", false)
        
        @db_arry = []
        @db_arry <<(create_checkbox)
        
        create_checkbox.add_item_listener do |e|
            WorkspaceCreator.new(@wXfgui)
            dispose()
        end
        
        home_dir = ENV['HOME']
        wXf_home_dir = "#{home_dir}/.wXf"
        Dir.foreach(wXf_home_dir) do |file|
            if File.extname(file) == ".db"
                file_name = File.basename(file)
                file_name.gsub!('.db', '')
                cb = JCheckBox.new(file_name, false)
                cb.add_item_listener do |e|
                    if e.stateChange == 1
                        disabler(cb.text)
                    elsif e.stateChange == 2
                        enabler(cb.text)
                    end 
                end
                @db_arry << (cb)
            end
        end
        
        sel = false
        
        choose_button = JButton.new "Choose"
        choose_button.addActionListener do |e|
            @db_arry.each do |cb|
                if cb.selected
                    sel = true
                    DatabaseManager.new(cb.text)
                    @wXfgui.restore
                    @wXfgui.send_log_text("Workspace restored: #{cb.text}", "Generic", nil, false)
                    dispose()
                    @wXfgui.initUI
                end
            end
            if sel == false
               JOptionPane.showMessageDialog self, "Please select a workspace",
                    "Error", JOptionPane::ERROR_MESSAGE
            end
        end  
        
        workspaceChooserModel = WorkspaceChooserModel.new(@db_arry)
        tree = JTree.new(workspaceChooserModel)
        renderer = WxfGui::CheckBoxNodeRenderer.new
        tree.set_cell_renderer(renderer)    
        tree.cell_editor = WxfGui::CheckBoxNodeEditor.new(tree, renderer)
        tree.editable = true
        tree.shows_root_handles = true
        jscrollpane = JScrollPane.new(tree)
       
        p1.addComponent(jscrollpane)
        sh1.addGroup p1
        sh1.addComponent choose_button
        
        sv1.addComponent(jscrollpane)
        p2.addComponent  choose_button
        sv1.addGroup p2


        self.setSize 400, 200
        self.setLocationRelativeTo nil
        self.setVisible true
        
        if not (@wXfgui.base.initialized)
             self.setDefaultCloseOperation JFrame::EXIT_ON_CLOSE
        end 
    end
    
    def disabler(name)
        @db_arry.each do |item|
            unless item.text == name
                item.enabled = false
            end
        end
    end
     
    def enabler(name)
        @db_arry.each do |item|
            item.enabled = true
        end
    end
     
end

end