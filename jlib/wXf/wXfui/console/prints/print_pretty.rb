module WXf
module WXfui
module Console
module Prints
  
  
  module PrintPretty
 
    
    
    #
    # Collects the various header values associated with a module
    # ...and dishes out actions
    #
    def self.collect(mod)
      if mod.respond_to?('name')
        print_name(mod)
      end
      
      if mod.respond_to?('version')
        print_version(mod)
      end
      
      if mod.respond_to?('author')
        print_author(mod)
      end

     if mod.respond_to?('description')
       print_description(mod)
     end
    
      if mod.respond_to?('references')
        print_references(mod)
      end 
      
      if mod.respond_to?('license')
         print_license(mod)
      end
      
      if mod.respond_to?('usage')
        "#{mod.usage}\n"
      end 
     
    end
    
    
    #
    # Responsible the name value associated with a module
    #
    def self.print_name(mod)
      str = ''
      mod_enum = mod.name.to_s
      mod_enum.each  {|line|
        format_line = line.lstrip
        str << ' ' + format_line
      }
       print("\n Name:\n")
       print(" ====\n")
       print("#{str}\n")      
    end
    
    
    #
    # Responsible the version value associated with a module
    #
    def self.print_version(mod)     
      str = ''  
      mod_enum = mod.version.to_s
      mod_enum.each  {|line|      
        format_line = line.lstrip         
        str << ' ' + format_line           
      }       
       print("\n Version:\n")
       print(" =======\n")
       print("#{str}\n")      
    end
    
    
    #
    # Responsible the author value associated with a module
    #
    def self.print_author(mod)      
      str = ''      
      mod_enum = mod.author.to_a      
      mod_enum.each {|item|        
        str << ' ' + item.to_s + "\n"        
      }      
      print("\n Author(s):\n")
      print(" ==========\n")
      print("#{str}\n")      
    end
    
    
    
   #
   # Prints the description value associated with a module
   #   
   def self.print_description(mod)   
    str = ''
    mod_enum = mod.description.to_s
    mod_enum.each  {|line|    
      format_line = line.lstrip       
      str << ' ' + format_line         
    }     
     print("\n Description:\n")
     print(" ============\n")
     print("#{str}\n")   
   end
   

   
    #   
    #  Prints the references value associated with a module
    #  
    def self.print_references(mod)      
      str = ''      
      mod_enum = mod.references.to_a      
      mod_enum.flatten.each {|item|        
        str << ' ' + item.to_s + "\n"        
      }      
      print("\n Reference(s):\n")
      print(" ============\n")
      print("#{str}\n")      
    end
    
   
    #
    # Responsible the name license associated with a module
    #
    def self.print_license(mod)         
      str = ''  
      mod_enum = mod.license.to_s
      mod_enum.each  {|line|      
        format_line = line.lstrip         
        str << ' ' + format_line           
      }       
       print("\n License:\n")
       print(" =======\n")
       print("#{str}\n\n")    
    end
   
   
   
 end
  
end end end end