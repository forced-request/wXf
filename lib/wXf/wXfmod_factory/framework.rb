# As of now, Oct 12, simply used to create an instance of the Module Loader
# Instantiated when initialize is called within Control. However, will allow for 
# ...greater flexibility.


module WXf
module WXfmod_Factory
  
  class Framework
    attr_accessor :modules
    
    module Transient
      attr_accessor :framework
      
      def initialize
       
      end
    end
    
    def initialize(print_symbols)
      self.class.send(:include, print_symbols)
      types = FUNCTION_TYPES
      sub = FwShim.new(self)
      self.modules = WXf::WXfmod_Factory::Mod_Loader.new(self,types)
      self.datahash = WXf::WXfmod_Factory::DataHash.new
    end      
  
    attr_accessor :datahash
    
  end
   
     class FwShim
       include Framework::Transient
       def initialize(fw)
       self.framework = fw 
       super()        
       end
       
     end
     
    
end end