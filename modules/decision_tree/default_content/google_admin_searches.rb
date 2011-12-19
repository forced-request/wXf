#!/usr/bin/env jruby

class Dti < WxfGui::DecisionTreeItem
  def initialize
      super(
              {
                'Name' => "Google Administrative Searches",
                'Package' => "Default Content",
                'Author'  => "cktricky",
                'Description' => %q{Uses Google's search engine to return a list of potential administrative interfaces exposed},
                'Buby' => false,
                'Required Modules' => "",
                'Optional Modules' => "",
                         
                     }
                     
                 )
    end
    
    def start
    end
    
end