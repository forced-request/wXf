require 'wXf/wXfui'
module WXf
module WXfmod_Factory

class Mod_Factory
    
  class << self
   include Framework::Transient
  end
  
  def framework
    self.class.framework
  end
  
  include WXf::WXfui::Console::Prints::PrintSymbols
  include WXf::WXflog::ModuleLogger
 
  attr_accessor :options, :name, :version, :license, :framework
  attr_accessor :description, :references, :author, :datahash
  
  def initialize(hash_info = {})
    self.options = OptsPlace.new
    self.name = hash_info['Name'] 
    self.version = hash_info['Version'] 
    self.description = hash_info['Description'] 
    self.references = hash_info['References'] 
    self.author = hash_info['Author'] 
    self.license = hash_info['License']
    self.datahash = ModDataHash.new(self)
  end
  
   
  def init_opts(opts)
   self.options.add_opts(opts)
   self.datahash.validate_store_items(self.options)    
  end
  
 
  
  
end

end
end
