module WXf
module WXfconductors
  
  class XmlRpc_Conductor
    
    attr_accessor :options
    
    def initialize(control)
      @control = control
    end
    
    #
    # Defines the type of module
    #
    def type
      XMLRPC
    end
    
  end 
  
end end 