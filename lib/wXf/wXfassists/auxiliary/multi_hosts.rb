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
      
      # Important to delete the RURL option
      delete_opts('RURL')
end
    
  
  #
  # This will very soon be able to do IP ranges but 
  # ...for now can only return the value of RURLS which is
  # ...essentially a file location
  #    
  def rurls
    line_array = []
    file = datahash['RURLS']
    if File.file?(file) and File.exist?(file)
      IO.foreach(file) do |line|
        line_array.push(line) 
      end   
    end 
     return line_array
  end
  
  
  #
  # We want to null-ify rurl
  #
  def rurl
    nil
  end
 
  
     
end end end end 