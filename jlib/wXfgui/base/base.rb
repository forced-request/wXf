require 'wXfgui/base/base_controller'

module WxfGui

class Base
  
  include WxfGui::BaseController
  
  def initialize
    super()
    Wxfgui.new(self)
  end
 
  def hash_value_at(arg0, hash)
    return unless arg0.kind_of?(Integer) && hash.kind_of?(Hash)
    val = nil 
    nrow = []
    hash.each do |key, row|
      nrow.concat(row)
    end
    val = nrow.fetch(arg0)
    return val
  end
  
  def next_item
    nrow = []
    sdi = selected_dt_items
    sdi.each do |k, row|
      row.each {|x| nrow<<(x.name)}
    end
    ri = nrow.rindex(in_focus.last.name)
    val = hash_value_at(ri + 1, sdi)
    return val    
  end
 
end

end