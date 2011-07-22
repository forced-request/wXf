module WXf
 module WXfmod_Factory
   
   
class DataHash < Hash
  
  attr_accessor :mod
  
  def initialize
  end
  
  def [](key)
   super(key)
  end
     
  #
  # Takes in an option pair, performs a sanity check (or will)
  # ... and splits to k,v pair. Calls store method
  #
  def validate_store_items(opts)
    opts.each_pair {|k,v|
    store_items(k, v.data)
  }
  end
  
  
  #
  # Final method which stores data
  # 
  def store_items(key,val)
   self.store(key, val)
  end
  
    
end

class ModDataHash < DataHash
  
  def initialize(mod)
    super()
    @mod = mod
  end
  
  def fetch(key)
   val = super(key)
  end
  
  def [](key)
  val = super(key)                         
  end
  
end

end end
 
 