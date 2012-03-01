class WebXploit < WXf::WXfmod_Factory::Auxiliary

  include WXf::WXfassists::Auxiliary::Wordpress
  

  def initialize
    super(
      'Name'        => 'WordPress Plugins Check',
      'Version'     => '1.0',
      'Description' => %q{
        
        Tests a WordPress site requesting all plugins that could potentially exist on the site, this is based off
        ethicalhack3r's "wpscan" but uses a plugin list by CG.
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
           'Output' => self,
           'Justify'  => 4,             
           'Columns' => 
           [
             'Body Length',
             'Response Code',
             'Plugin Name',
             'Vulnerability',
             'Reference',
           ])
         list_items.each do |length, code, found, index, name, vuln, ref| 
           tbl.add_ritems([length, code, name, vuln, ref])
         end
       tbl.prnt    
  end
  
  def run
    list = []
    enumerate_all_plugins(3, true).each do |row|
     code = row[1]
     found = row[2]
     index = row[3]
     name = row[4]
    
     if found
      ref_data = fetch_wordpress_vuln_by_name("#{name}")
      if ref_data
        ref_data.each do |ref_row|
          row.push("#{ref_row[0]}", "#{ref_row[1]}")
        end
      else
        row.push("none", "none")
      end
      list.push(row) 
     end
    
    end
    
    if !list.empty?
      print_found(list)
    else
      prnt_err("No plugins discovered")
    end
    
  end

end