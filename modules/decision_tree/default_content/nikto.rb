#!/usr/bin/env jruby

class Dti < WxfGui::DecisionTreeItem
  def initialize
      super(
              {
                'Name' => "Nikto Analysis",
                'Package' => "Default Content",
                'Author'  => "cktricky",
                'Description' => %q{Imports and analyzes the results from a dirbuster scan},
                'Buby' => false,
                'Required Modules' => "",
                'Optional Modules' => "",
               }
                     
            )
    end
    
    def start
    end
    
end