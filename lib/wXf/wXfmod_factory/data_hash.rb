module WXf
 module WXfmod_Factory
   
   
class DataHash < Hash
  
  attr_accessor :mod
  
  def initialize()
  @trigger = Hash.new
  end
    
  def []=(key,val)
    super(key,val)
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
    store_items(k, "#{v.data.to_s}")
  }
  end
  
  
  #
  # Final method which stores data
  # 
  def store_items(key,val)
   self.store(key, val)
  end
  
  #
  #
  #
  def check_case(k)
  self.each_key {|retkey|
    if(retkey.downcase == k.downcase)
      return retkey
    end
  }
  return k
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
 
 