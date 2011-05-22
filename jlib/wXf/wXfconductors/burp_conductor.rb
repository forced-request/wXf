module WXf
module WXfconductors
  
  class Burp_Conductor
    
    attr_accessor :options, :desc
    
    def initialize(control)  
      self.options = {
        'BURP'    => "",
        'VERSION' => ""                        
      }    
         
      burp = control.options['Burp']
        if not burp.nil?
          self.options['BURP'] = "#{burp}"                
        end   
            
      self.desc = {
        'BURP'    => "Location of BurpSuite Jar file",
        'VERSION' => "Version of BurpSuite"
      }
        
    end
        
    
    #
    # Defines the type of module
    #
    def type
      BURP
    end
   
    def dis_required_opts
        # Display the commands
        tbl = WXf::WXfui::Console::Prints::PrintTable.new(
        'Justify'  => 4,             
        'Columns' => 
        [
        'Name',
        'Current Setting',
        'Description',
                               
         ])
         self.options.each { |k,v|
         if (!v)
         v = ""
         end
         tbl.add_ritems([k.to_s,v.to_s, self.desc[k].to_s ])
         }
         tbl.prnt
        
    end
      
    def usage
      $stderr.puts("\n"+"Burp options:")
      dis_required_opts  
    end
   
  end
  
end end