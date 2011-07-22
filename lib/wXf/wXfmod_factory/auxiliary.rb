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
   
   
  end
  
class AuxMixer < Auxiliary
  
  include WXf::WXfassists::General::MechReq
  include WXf::WXfassists::Auxiliary::MultiHosts
    
  def initialize
   
  end

end
  
end end