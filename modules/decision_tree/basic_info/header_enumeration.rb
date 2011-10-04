#!/usr/bin/env jruby

class Dti < WxfGui::DecisionTreeItem
       
       def initialize
           super(
               {
                   'Name' => "Header Enumeration",
                   'Package' => "Basic Info",
                   'Author'  => "cktricky",
                   'Description' => %q{This leverages pre-built modules to assist a user in identifying their target and the target's potential weaknesses
                   based on the headers},
                   'Buby' => false,
                   
               }
               
           )
       end
       
   end