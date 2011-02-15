module WXf
module WXfui
module Console
module Prints

  #!/usr/bin/env ruby
  # Table format to give it the look like our favorite network exploitation framework
  #
  
  # Takes 3 pieces of input (for now)
  # Title, Justify, Columns 
  #
  
  class PrintTable
    
    def initialize(opts={})
      self.title = opts['Title'] || ''
      self.justify = opts['Justify'] || 4
      self.columns = opts['Columns'] || []
      self.col_hash = {}
      self.rows = []
      self.ritems_collect = {}    
     
      self.columns.each {|item|
      cnt = self.columns.index(item)
      col_hash[cnt] = {}
      col_hash[cnt]['Length'] = item.length
        }
      
    end
    
  
    #
    # First method called, adds each row as an array with its own index
    #
    def add_ritems(items)
        self.rows << items
    end
      
    
    #
    # Compare determines whether the items in a column or the column name are bigger
    # ...its job is to determine the biggest number and set col_hash[some_index_#]['Length'] value
    # ...which is needed for later basic math routine
    #
    def compare    
          rows.each_with_index {|ritem,index|
          ritem.each_with_index {|item, idx|
       if col_hash.has_key?(idx) and col_hash[idx]['Length'] < item.length
          col_hash[idx]['Length'] = item.length
       end
          }
     }
    end
       
   
    #
    # Space essentially takes in the item and its index value. This index
    # ...value is used in calling the length value in col_hash, and determining
    # ...how much to space to add before the next column item
    #
    def space(item, index)
      strn = ''
      val = nil
      if col_hash.has_key?(index) and (col_hash[index]['Length']  == item.length)
        val = 3
      elsif (col_hash.has_key?(index)) and (col_hash[index]['Length'] > item.length)
         diff = col_hash[index]['Length'] - item.length
         val = diff + 3
      end
      pad = ' ' * val
      strn << item.to_s + pad 
    end
    
    
    #
    # This is for column items (basically the column names like 'Name', 'Description', etc.
    # We prepend some space depending on the items specified in opts['Justify'], decide when it is the
    # last item and if it is we append a newline character ("\n")
    #
    def col_strn
      strn = ''
      buff = ' ' * justify
      strn << buff
      len = columns.length
      columns.each_with_index {|citem, index|
      if len - index == 1
      strn << citem.to_s + "\n"
      else
      strn << space(citem,index)
      end
      }
      return strn
    end
    
    
    #
    # This is the separator bar between column headers and the actualy column names
    # It is really no different from the col_strn operation except that we are substituting
    # actual words for a single dash '-'
    #
    def col_sep
      strn = ''
      buff = ' ' * justify
      strn << buff
      len = columns.length
      columns.each_with_index {|citem, index|
      sep_bar = '-' * citem.length
      if len - index == 1
      strn << sep_bar.to_s + "\n"
      else
      strn << space(sep_bar,index)
      end
      }
      return strn
    end
    
    
    #
    # Title is the easiest operation. We determine if a title has a value other than the default ''
    # ...(or nil) and then count its length, place it on the strn. Next, we append a newline character
    # ...and for every character in opts['Title'] we place a '=' on the strn (below the Title)
    #
    def title_format
       strn = ''
       if not (title == '') or title.nil?
        strn << title + "\n" + "=" * title.length + "\n\n"
       end
       return strn
    end
  
    #
    # This is the method called immediately after every row has been added (add_ritems)
    # ...this will kick off placing a Title, Title Seperator, Column, Column Seperator and then
    # ...this method handles the actual row placement
    #
    def prnt
      compare
      strn = ''
      buff = ' ' * justify
      strn << title_format
      strn << col_strn
      strn << col_sep
      strn << buff
      rows.each_with_index do |item, index|  
      len = item.length  
      
      item.each_with_index {|i,idx|
      if len - idx == 1
      strn << i.to_s + "\n" + buff
      else 
      strn << space(i, idx)
      end
      }
      end
      
      
     print("\n" + strn + "\n")
    
    end
    
    attr_accessor :title, :justify, :columns, :col_hash, :ritems_collect, :rows
    
  
end

end end end end