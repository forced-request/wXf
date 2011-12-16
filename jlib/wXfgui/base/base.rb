require 'wXfgui/base/base_controller'

module WxfGui

class Base
  
  include WxfGui::BaseController
  
  def initialize
    super()
    Wxfgui.new(self)
  end
 
end

end