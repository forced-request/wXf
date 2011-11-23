require 'java'

java_import java.awt.event.MouseAdapter

module WxfGui
  
  class ScaPopupMenu < MouseAdapter
  
    def initialize(table)
      @table = table
      super()
    end
  
    def mousePressed(event)
      if event.isPopupTrigger
        test_popup(event)
      end
    end
  
    def mouseReleased(event)
      if event.isPopupTrigger
        test_popup(event)
      end
    end
  
    def test_popup(event)
      puts "test_popup"
    end
  
    def mouseClicked(event)
      if event.getClickCount == 2
        row = @table.getSelectedRow
        if row and row.kind_of?(Integer)
          result = @table.getValueAt(row, 0)
          open_dialog(result)
        end 
      end
    end
  
    def open_dialog(file)
      fc = ''
      if File.exists?(file) and File.file?(file)
       # fc = File.read(file).to_s
        IO.readlines(file).each_with_index do |line, idx|
          idx +=1
          fc << "#{idx}>   #{line}"
        end
        fopenframe = FileOpenFrame.new(fc, file.to_s)
      end
    end
  
  end

end