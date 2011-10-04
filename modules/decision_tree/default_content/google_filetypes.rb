#!/usr/bin/env jruby

class Dti < WxfGui::DecisionTreeItem
  def initialize
      super(
              {
                'Name' => "Google Filetype Searches",
                'Package' => "Default Content",
                'Author'  => "cktricky",
                'Description' => %q{Uses Google's search engine to return a list of interesting files exposed by the application},
                'Buby' => false,
                         
                     }
                     
                 )
    end
end