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
  
  def run
    enumerate_vuln_plugins(3, true).each do |row|
     code = row[0]
     found = row[1]
     index = row[2]
     name = row[3]
     vuln = row[4]
     ref = row[5]
    
     if found
       prnt_plus("Found: plugin #{name}")
       prnt_plus("#{rurl}/wp-content/plugins/#{name} via response code: #{code}")     
     end
    
    end
  end

end