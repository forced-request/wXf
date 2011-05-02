require 'wXf/wXfui'

module WXf
module WXfassists
module Auxiliary
module MultiHosts  
  
  include WXf::WXfui::Console::Prints::PrintSymbols    
  
  #
  # Global Options are created
  #
  def initialize(hash_info={})    
    super
      init_opts([
        WXf::WXfmod_Factory::OptString.new('RURLS', [true, 'Target addresses file', 'rurls/some_urls.txt']),
      ])
     delete_opts('RURL')
end
      
  def rurls
   datahash['RURLS']
  end
  
  def rurl
    nil
  end
  
end end end end 