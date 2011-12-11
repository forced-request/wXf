#!/usr/bin/env jruby

import java.awt.FlowLayout
import java.awt.Dimension
import javax.swing.JPanel
import javax.swing.JScrollPane
import javax.swing.JTable
import javax.swing.JTextField
import javax.swing.JCheckBox
import javax.swing.JComboBox
import javax.swing.JButton
import java.awt.event.MouseListener
import javax.swing.table.DefaultTableModel
#import javax.swing.event.TableModelListener
import javax.swing.ListSelectionModel

module WxfGui
   
class ScopeTable <  DefaultTableModel
  # include TableModelListener
   
   def initialize
      super
      init
   end
   
   def init
       self.add_column("id")
       self.add_column("in/out")
       self.add_column("prefix")
       self.add_column("host")
       self.add_column("port")
       self.add_column("path")
   end 
   
   def isCellEditable(row, col)
      return false
   end
   
   def delete_all_rows
      i = 0
      while i < self.getRowCount()
         self.removeRow(i)
         i+1
      end
   end   
   
end 
   
class ScopePanelExtension < JPanel
   
   attr_accessor :combo_box_pre, :combo_box_io, :host_field, :port_field, :path_field, :id_field
   
   def initialize
      super(FlowLayout.new(FlowLayout::LEFT))
      init
   end
   
   def init
       combo_prefix = ["https", "http"]
       self.combo_box_pre = JComboBox.new
       combo_prefix.each do |pre|
           self.combo_box_pre.addItem(pre)
       end
       
       combo_inout = ["in", "out"]
       self.combo_box_io = JComboBox.new
       combo_inout.each do |io|
           self.combo_box_io.addItem(io)
       end
       
       self.id_field   = JTextField.new(3)
       self.id_field.editable = false
       self.host_field = JTextField.new(14)
       self.port_field = JTextField.new(5)
       self.path_field = JTextField.new(22)
       
       add(id_field)
       add(combo_box_io)
       add(combo_box_pre)
       add(host_field)
       add(port_field)
       add(path_field)
   end
   
end
   
class ScopePanel < JPanel
   include WxfGui::ScopeDatabaseManagerModule
   include MouseListener
  
  def initialize
    super
    init
  end
  
  def init
     
       
       @scope_table = ScopeTable.new
       @table = JTable.new(@scope_table)
       @table.setPreferredScrollableViewportSize(Dimension.new(500, 70))
       @table.setFillsViewportHeight(true)
       @table.setSelectionMode(ListSelectionModel.SINGLE_SELECTION)
       
       @spe = ScopePanelExtension.new
       add_button  = JButton.new("add")
       add_button.add_action_listener do |e|
         cb_in = @spe.combo_box_io.selected_item
         cb_pre = @spe.combo_box_pre.selected_item
         tf_host = @spe.host_field.text
         tf_port = @spe.port_field.text
         tf_path = @spe.path_field.text
         
         db_add_handler(cb_in, cb_pre, tf_host, tf_port, tf_path)         
       end
       edit_button = JButton.new("edit")
       edit_button.add_action_listener do |e|
          num = @table.getSelectedRow.to_i  
          if num >= 0
            rows = retrieve_scope_table
            update_scope_fields(num, rows)
            delete_row(@table.getSelectedRow)
         end
          
       end 
       rem_button  = JButton.new("remove")
       rem_button.add_action_listener do |e|
         if @table.getSelectedRow >= 0
            delete_row(@table.getSelectedRow)
         end
       end
       
       jpane = JScrollPane.new(@table)
      
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
      p  = layout.createParallelGroup
      p1 = layout.createParallelGroup
      p2 = layout.createParallelGroup
      p3 = layout.createParallelGroup
      
      layout.setHorizontalGroup sh1
      layout.setVerticalGroup sv3
      
      
      p.addComponent(jpane)
      p.addComponent(@spe)
      p1.addComponent(add_button)
      p1.addComponent(edit_button)
      p1.addComponent(rem_button)     
      sh1.addGroup(p)
      sh1.addGroup(p1)
      
      sv1.addComponent(jpane)
      sv1.addComponent(@spe)
      sv1.addGroup(p3)
      
      sv2.addComponent(add_button)
      sv2.addComponent(edit_button)
      sv2.addComponent(rem_button)
      p2.addGroup(sv1)
      p2.addGroup(sv2)
      
      sv3.addGroup(p2)
      
      layout.linkSize SwingConstants::HORIZONTAL, 
          add_button, edit_button, rem_button
      
  end
  
  def db_add_handler(*params)
     scope, prefix, host, port, path = params
     
     if host.empty?
        error("host")
      return 
     end
     
     if port.empty?
        error("port")
      return
     elsif port.to_i == 0 || port.to_i > 65535
        error("port")
       return 
     end
     
      db_add_scope(scope, prefix, host, port.to_i, path)
      reset_scope_panel_ext     
  end
  
  def db_add_scope(*params)
     #Stubbed...
     #This is where we will do more stringent checks on the host name and such. 
     super(*params)
     restore
  end
  
  def delete_row(rownum)
     row_num_db = rownum.to_i + 1
     db_remove_scope_by_row(row_num_db)
     restore
  end
  
  def update_scope_fields(key, rows)
     row = rows[key]
     id = row[0].to_s   || ""
     ss = row[1].to_s   || "in"
     pre = row[2].to_s  || "https"
     host = row[3].to_s || ""
     port = row[4].to_s || ""
     path = row[5].to_s || ""
     
     @spe.id_field.text = id
     @spe.combo_box_io.selected_item = ss
     @spe.combo_box_pre.selected_item = pre
     @spe.host_field.text = host
     @spe.port_field.text = port
     @spe.path_field.text = path  
  end
  
  def reset_scope_panel_ext
      @spe.id_field.text = ""
      @spe.combo_box_io.selected_item = "in"
      @spe.combo_box_pre.selected_item = "https"
      @spe.host_field.text = ""
      @spe.port_field.text = ""
      @spe.path_field.text = ""    
  end
  
  def restore
   @scope_table.delete_all_rows  
   table_data = retrieve_scope_table
   #Lets get the results
   if table_data.kind_of?(Array) and table_data.length > 0
      table_data.each do |row|
         @scope_table.add_row(row.to_java)
      end 
   end   
  end
  
  def error(error_type)
     if error_type and error_type.kind_of?(String) and error_type != ''
      JOptionPane.showMessageDialog self, "The was an error in the following field: #{error_type}",
                    "Error", JOptionPane::ERROR_MESSAGE
     end      
  end
  
end

end