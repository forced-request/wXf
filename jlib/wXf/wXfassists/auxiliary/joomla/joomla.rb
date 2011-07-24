require 'wXf/wXfui'

module WXf
module WXfassists
module Auxiliary
module Joomla
  
  # Important to include this so we can make HTTP requests
  include WXf::WXfassists::General::MechReq     
  
  def joomla_strings
   {
    "1.5" => ["Joomla! 1\.5", "1\.5\..{1}"],
    "1.0" => [ "Joomla! 1\.0"],
   }
  end

  def detect_version
    res = mech_req({
      'method' => 'GET',
      'RURL' => rurl,        
    })
    
    if res and res.respond_to?('body')
      joomla_strings.each do |key, val_array|
        val_array.each {|reg_item| 
         if res.body.match(/#{reg_item}/)
           return "#{key}"
         else
           return nil
         end
        }
      end
    end
  end
  
end

end end end