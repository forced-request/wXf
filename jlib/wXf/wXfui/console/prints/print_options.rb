module WXf
module WXfui
module Console
module Prints


module PrintOptions
  

  #
  # Shows available exploits in the database
  #
  def show_exploits
    exploits = framework.modules.mod_pair['exploit'].sort
    # Display the commands
      tbl = WXf::WXfui::Console::Prints::PrintTable.new(
        'Title'  => "Exploits",
        'Justify'  => 4,             
        'Columns' => 
        [
          'Name',
          'Description'
        ])
        
     exploits.each do |item, obj|
      name =  "exploit/#{item}"
      desc =  obj.description.to_s.lstrip.rstrip
      tbl.add_ritems([name, desc[0..50]])
     end
    tbl.prnt       
   end
 
   
  #
  # Show payload mods
  #    
  def show_payloads
   list = framework.modules.mod_pair['payload'].sort
   # Display the commands
   tbl = WXf::WXfui::Console::Prints::PrintTable.new(
     'Title'  => "Payloads",
     'Justify'  => 4,
     'Columns' =>
       [
         'Name',
         'Description'
       ])
                    
     list.each {|item, obj|
       name =  "payload/#{item}"
       desc =  obj.description.to_s.lstrip.rstrip
       tbl.add_ritems([name,desc[0..50]])
     }
   tbl.prnt
  end
  
    
  #
  # Show auxiliary mods
  #    
  def show_auxiliary
   list = framework.modules.mod_pair['auxiliary'].sort
   # Display the commands
   tbl = WXf::WXfui::Console::Prints::PrintTable.new(
     'Title'  => "Auxiliary",
     'Justify'  => 4,
     'Columns' =>
       [
         'Name',
         'Description'
       ])
                    
     list.each {|item, obj|
       name =  "auxiliary/#{item}"
       desc =  obj.description.to_s.lstrip.rstrip
       tbl.add_ritems([name,desc[0..50]])
     }
   tbl.prnt
  end
  
 
 #
 # Shows available buby modules
 #
  def show_buby
      list = framework.modules.mod_pair['buby'].sort
      # Display the commands
      tbl = WXf::WXfui::Console::Prints::PrintTable.new(
        'Title'  => "Buby",
        'Justify'  => 4,
        'Columns' =>
      [
       'Name',
       'Description'
      ])
                     
      list.each {|item, obj|
        name =  "buby/#{item}"
        desc =  obj.description.to_s.lstrip.rstrip
        tbl.add_ritems([name,desc[0..50]])
      }
    tbl.prnt
  end       
  
  
  #
  # show content
  #
  def show_content
    list = WXf::CONTENT_TYPES.sort_by {|k,v| k.to_i}
    tbl = WXf::WXfui::Console::Prints::PrintTable.new(
      'Title'  => "Content-Types",
      'Justify'  => 4,            
      'Columns' => 
      [
        'Id',
        'Content-Type'
      ])
      
        list.each {|id, name|
          tbl.add_ritems([id,name])
        }
    tbl.prnt
  end  
  
  
  #
  # Show lfiles
  #
  def show_lfiles
       list = framework.modules.lfile_load_list.sort
       # Display the commands
       tbl = WXf::WXfui::Console::Prints::PrintTable.new(
         'Title'  => "Local Files",
         'Justify'  => 4,             
         'Columns' => 
           [
             'Name',
            ])
        list.each {|name, path|
          tbl.add_ritems([name]) 
         }
       tbl.prnt
  end
  
  
  #
  #
  #
  def show_rurls
    list = framework.modules.rurls_load_list.sort
         # Display the commands
         tbl = WXf::WXfui::Console::Prints::PrintTable.new(
           'Title'  => "Rurl(s) Files",
           'Justify'  => 4,             
           'Columns' => 
             [
               'Name',
              ])
     list.each {|name, path|
        tbl.add_ritems([name]) 
      }
    tbl.prnt
  end

  
  #
  # Show a list of user-agents
  #
  def show_ua
  list = WXf::UA_MAP.sort_by {|k,v| k.to_i}
  # Display the commands
    tbl = WXf::WXfui::Console::Prints::PrintTable.new(
      'Title'  => "User-Agents",
      'Justify'  => 4,             
      'Columns' => 
        [
          'Id',
          'User-Agent'
        ])
                          
     list.each {|id, name|
       tbl.add_ritems([id,name]) 
     }
   tbl.prnt
  end  
  
    # 
    # When an in_focus exists this method becomes the de-facto to module specific options
    #
    def show_options(activity)      
     if activity.type.match(/(exploit|auxiliary|buby)/)      
       # Display the commands
           tbl = WXf::WXfui::Console::Prints::PrintTable.new(
           'Title' => "Module Options:",
           'Justify'  => 4,
           'Columns' =>
           [
             'Name',
             'Current Setting',
             'Required',
             'Description',
                                      
           ])
                   
           activity.options.sarr.each { |item|
           name, option = item
           val = activity.datahash[name]
           tbl.add_ritems([name,val, "#{option.required}", option.desc]) 
           }
           tbl.prnt        
        
     elsif activity.type == "webserver"
      activity.usage    
     elsif activity.type == "burp"
       activity.usage
     end
     
      if activity.respond_to?('payload') and ! activity.payload.nil?
       if activity.payload.type == 'payload' and activity.payload.type.match(/payload/)   
       # Display the commands
           tbl = WXf::WXfui::Console::Prints::PrintTable.new(
           'Title' => "Payload Options:",
           'Justify'  => 4,
           'Columns' =>
           [
             'Name',
             'Current Setting',
             'Required',
             'Description',
                                      
           ])
                   
           activity.payload.options.sarr.each { |item|
           name, option = item
           val = activity.payload.datahash[name] 
           tbl.add_ritems([name,val, "#{option.required}", option.desc]) 
           }
           tbl.prnt        
          
          end  
       end 
    end
    
  #
  # Show Remote File Inclusions Strings
  #
  def show_rfi
    list = WXFDB.get_rfi_list.sort
     # Display the commands
       tbl = WXf::WXfui::Console::Prints::PrintTable.new(
         'Title'  => "RFI List",
         'Justify'  => 4,             
         'Columns' => 
           [
             'Name',
             'Description',
             'Platform',
             'Language'
           ])
                             
        list.each {|name, desc, platform, lang|
          tbl.add_ritems([name,desc, platform, lang]) 
        }
      tbl.prnt     
  end 
    
  
end

end end end end