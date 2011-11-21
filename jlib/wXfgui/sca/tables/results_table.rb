require 'wXfgui/database'

module WxfGui
  
  class ResultsTable <  DefaultTableModel
    # include TableModelListener
     include WxfGui::DatabaseManagerModule
     def initialize
        super()
        init
     end
     
     def init
         self.add_column("file")
         self.add_column("line number")
         self.add_column("string match")
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
     
     def remove_results
     end
     
     def insert_results(*params)
       #Make sure we make an information window if empty
       if params.kind_of?(Array) and params.length > 0
          params.each do |rows|
            rows.each do |row|
              file         = row[0]
              line_number  = row[1]
              string_match = row[2]
              db_add_string_results(file, line_number, string_match)
            end 
          end
       else
         #Show an error
       end
       update_results_fields
     end
     
      def update_results_fields  
        table_data = retrieve_string_results
        #Lets get the results
        if table_data.kind_of?(Array) and table_data.length > 0
          table_data.each do |row|
            self.add_row(row.to_java)
          end 
        end   
      end
      
      def restore
        delete_all_rows
        update_results_fields
      end
     
     def restore_results
     end
     
  end 
  
  
end