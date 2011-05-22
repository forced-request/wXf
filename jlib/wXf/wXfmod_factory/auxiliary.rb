module WXf
module WXfmod_Factory
  
  
  class Auxiliary < Mod_Factory
 
    attr_accessor :type
    include WXf::WXfassists::General::MechReq
    def initialize(hash_info ={})
      inc_mod = self.class      
      inc_mod_sort(inc_mod)
     super   
    end

    
    #
    #
    #
    def inc_mod_sort(inc_mod)
      if inc_mod.include?(WXf::WXfassists::Auxiliary::MultiHosts)
        if inc_mod.include?(WXf::WXfassists::General::MechReq)
         AuxMixer.new
        end
      end
    end
    
    #
    # Defines the type of module
    #
    def type
      AUXILIARY
    end
    
    def dis_required_opts
      # Display the commands
      tbl = WXf::WXfui::Console::Prints::PrintTable.new(
      'Justify' => 4,
      'Columns' =>
      [
       'Name',
       'Current Setting',
       'Required',
       'Description',
                              
      ])
                  
     self.options.sarr.each { |item|
     name, option = item
     val = datahash[name] || option.data.to_s
     tbl.add_ritems([name,val, "#{option.required}", option.desc]) 
     }
     tbl.prnt
   end
   
   def usage       
     $stderr.puts("\n"+"Auxiliary Module options:")
     dis_required_opts   
   end
   
  end
  
class AuxMixer < Auxiliary
  
  include WXf::WXfassists::General::MechReq
  include WXf::WXfassists::Auxiliary::MultiHosts
    
  def initialize
   
  end

end
  
end end