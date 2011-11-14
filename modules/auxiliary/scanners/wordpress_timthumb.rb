class WebXploit < WXf::WXfmod_Factory::Auxiliary
  include WXf::WXfassists::Auxiliary::Wordpress

  def initialize
    super(
      'Name'        => 'WordPress Timthumb 0-day scanner',
      'Version'     => '1.0',
      'Description' => %q{
        
        Scans wordpress theme directories for vulnerable timthumb files
                        },
      'Author'      => ['John M. Poulin'] ,
      'License'     => WXF_LICENSE,
      'References'  =>
        [
          [ 'URL', 'http://blog.sucuri.net/2011/08/timthumb-security-vulnerability-list-of-themes-including-it.html' ]
        ]
    )
      
  end
  
  def print_found(list)
    list_items = list
       # Display the commands
         tbl = WXf::WXfui::Console::Prints::PrintTable.new(
           'Justify'  => 3,             
           'Columns' => 
           [
             'Response Code',
             'Plugin Name',
             'Path',	
           ])
         list_items.each do |code, found, index, name, path|  
           tbl.add_ritems([code, name, path])
         end
       tbl.prnt    
  end
  
  def run
    list = []
    enumerate_timthumb(3, true).each do |row|
     code = row[0]
     found = row[1]
     index = row[2]
     name = row[3]
    
     if found
      list.push(row) 
     end
    
    end
    
    if !list.empty?
      print_found(list)
    else
      prnt_err("No instances of timthumb.php discovered")
    end
    
  end

end
