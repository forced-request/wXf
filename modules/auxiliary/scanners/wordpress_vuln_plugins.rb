class WebXploit < WXf::WXfmod_Factory::Auxiliary

  include WXf::WXfassists::Auxiliary::Wordpress
  

  def initialize
    super(
      'Name'        => 'WordPress Vulnerable Plugins Check',
      'Version'     => '1.0',
      'Description' => %q{
        
        Lists vulnerable WordPress plugins that exist on the site, this is based off
        ethicalhack3r's "wpscan".
                        },
      'Author'      => ['CG', 'CKTRCKY'] ,
      'License'     => WXF_LICENSE,
      'References'  =>
        [
          [ 'URL', 'http://www.ethicalhack3r.co.uk/security/introducing-wpscan-wordpress-security-scanner/' ]
        ]
    )
      
  end
  
  def print_found(list)
    list_items = list
       # Display the commands
         tbl = WXf::WXfui::Console::Prints::PrintTable.new(
           'Justify'  => 4,             
           'Columns' => 
           [
             'Body Length',
             'Response Code',
             'Plugin Name',
             'Vulnerability',
             'Reference'
           ])
         list_items.each do |length, code, found, index, name, vuln, ref|  
           tbl.add_ritems([length,code, name, vuln, ref])
         end
       tbl.prnt    
  end
  
  def run
    list = []
    enumerate_vuln_plugins(3, true).each do |row|
     code = row[1]
     found = row[2]
     index = row[3]
     name = row[4]
     vuln = row[5]
     ref = row[6]
    
     if found
      list.push(row) 
     end
    
    end
    
    if !list.empty?
      print_found(list)
    else
      prnt_err("No vulnerable plugins discovered")
    end
    
  end

end