require 'wXf/wXfui'

module WXf
module WXfassists
module Auxiliary
module Joomla
  
  # Important to include this so we can make HTTP requests
  include WXf::WXfassists::General::MechReq
      
  def detect_version(url)
    
  end
  
  def joomla_strings 
   [
    "Joomla! 1\.5",
    "1\.5\."  
   ]
  end

  
end

end end end