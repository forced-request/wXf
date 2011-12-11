require 'wXfgui/base/base_controller'

module WxfGui

class Base
  
  include WxfGui::BaseController
  attr_accessor :base
  
  def initialize
    Wxfgui.new(self)
  end

end

end