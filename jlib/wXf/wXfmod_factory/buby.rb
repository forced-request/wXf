module WXf
module WXfmod_Factory

class Buby < Mod_Factory
  
  def initialize(hash_info ={})
   super   
  end
  
  
  def dis_required_opts
    # Display the commands
    tbl = WXf::WXfui::Console::Prints::PrintTable.new(
      'Justify' => 4,
      'Columns' =>
      [
        'Name',
        'Current Setting',
        'Required',
        'Description',                                
       ])
                    
    self.options.sarr.each { |item|
      name, option = item
      val = datahash[name] || option.data.to_s
      tbl.add_ritems([name,val, "#{option.required}", option.desc]) 
    }
   tbl.prnt
  end
     
     def usage       
       $stderr.puts("\n"+"Buby Module options:")
       dis_required_opts   
     end
     
     
  def type
    BUBY
  end
  
  
end

end end