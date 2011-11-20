module WxfGui
  
  class ResultsTable <  DefaultTableModel
    # include TableModelListener
     
     def initialize
        super
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
     
  end 
  
  
end