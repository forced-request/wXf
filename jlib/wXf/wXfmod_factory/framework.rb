# As of now, Oct 12, simply used to create an instance of the Module Loader
# Instantiated when initialize is called within Control. However, will allow for 
# ...greater flexibility.


  module WXf
  module WXfmod_Factory
    
    class Framework
      attr_accessor :modules, :subp
      
     
      
      module Transient
        attr_accessor :framework
      end
      
      def initialize
        types = FUNCTION_TYPES
        self.subp = FwShim.new(self)
        self.modules = WXf::WXfmod_Factory::Mod_Loader.new(self,types)
        self.datahash = WXf::WXfmod_Factory::DataHash.new
      end      
    
      attr_accessor :datahash
      
    end
     
       class FwShim
         include Framework::Transient
         def initialize(fw)
         self.framework = fw         
         end
         
       end
       
      
 end end