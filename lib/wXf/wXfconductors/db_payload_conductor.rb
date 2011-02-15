module WXf
module WXfconductors
  
  class Db_Payload_Conductor
    
    attr_accessor :payload
    
    
    #
    # Initializes with an instance of a payload
    #
    def initialize(name)
      self.payload =  WXf::WXfdb::Payload.new(payload_call("#{name}")[0])   
      rescue    
    end
    
    
    #
    # 
    #
    def type
      DB_PAY     
    end
        
      
    #
    # Call to the payload portion of the db
    #
    def payload_call(name)    
    wxf.db.get_payload_by_name(name)    
    end
      
    
    #
    # Creates an instance of the core class from which to make db calls
    #
    def wxf 
    WXf::WXfdb::Core.new(WXFDIR,1)   
    end


 end
 
end end