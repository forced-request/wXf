require 'java'

import javax.swing.table.DefaultTableModel
require 'wXfgui/database'

module WxfGui

  class DtAnalysisTable <  DefaultTableModel
    
    include WxfGui::DecisionTreeDatabaseManager

     def initialize
        super()
        init
     end
     
     def init
         self.add_column("id")
         self.add_column("package")
         self.add_column("required modules")
         self.add_column("optional modules")
         self.add_column("completed")
         self.add_column("attack probability")
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
  
    def reset
      delete_all_focused
      restore
    end
     
    def update_row
      delete_all_rows
      table_data = retrieve_focused_dt
      #Lets get the results
      if table_data.kind_of?(Array) and table_data.length > 0
        table_data.each do |row|
          self.add_row(row.to_java)
        end 
      end   
    end
      
    def restore
      delete_all_rows
      update_row
    end

     
  end 
  
  
end