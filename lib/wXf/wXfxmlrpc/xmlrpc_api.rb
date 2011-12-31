module WXf
  module WXfXmlRpc

  class XmlRpcApi
    
    def initialize
    end
    
    def sumAndDifference(a, b)
      { "sum" => a + b, "difference" => a - b }
    end
        
  end

end end 
