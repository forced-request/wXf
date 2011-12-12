require 'wXfgui/base/base_controller'

module WxfGui

class Base
  
  include WxfGui::BaseController
  
  def initialize
    Wxfgui.new(self)
    super()
  end
 
end

end