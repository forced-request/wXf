#!/usr/bin/env jruby

class Dti < WxfGui::DecisionTreeItem

  def initialize
            super(
                {
                    'Name' => "HTTP Methods Allowed",
                    'Package' => "Basic Info",
                    'Author'  => "cktricky",
                    'Description' => %q{wXf sends an OPTIONS request to identify allowed HTTP Methods},
                    'Buby' => false,
                    
                }
            )
    end

end