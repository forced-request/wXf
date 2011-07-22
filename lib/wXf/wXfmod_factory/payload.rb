module WXf
module WXfmod_Factory
  
  
  class Payload < Mod_Factory
       
    
    attr_accessor :type, :control
    
    def initialize(hash_info ={})
      self.control = nil
      super
    end

    #
    # Defines the type of module
    #
    def type
      PAY
    end
  
  end

  
end end 