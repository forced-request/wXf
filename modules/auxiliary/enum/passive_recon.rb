class WebXploit < WXf::WXfmod_Factory::Auxiliary   
  
  include WXf::WXfassists::General::MechReq
  
  attr_accessor :row
  
  def initialize
    super(

            'Name'        => 'Passive Recon',
            'Version'     => '1.0',
            'Description' => %q{
            This module will send a single request and then analyze the headers in the response to determine technologies used by the application
            utilized by the target.                       
            
            },
            'References'  =>
             [
                [ 'URL', 'https://www.owasp.org/index.php/Category:OWASP_Cookies_Database' ],
                [ 'URL', 'http://projects.webappsec.org/w/page/13246925/Fingerprinting']  
             ],
            'Author'      => [ 'CKTRICKY',],
            'License'     => WXF_LICENSE
  
    )
          
      init_opts([
          OptString.new('REDIRECT', [false, 'Set to false if you prefer the 301/302 not be followed ', true]),
          OptString.new('METHOD', [false, 'By default the value is GET, changed to POST if you choose', "GET"])
         ])
  end
  
  
  #
  # List of cookies
  #
  def cookie_list 
    
    {
      'JSESSIONID'    => 'J2EE Application server',
      'ASPSESSIONID'  => 'Microsoft Internet Information Services 5.0 or 6.0',
      'ASP.NET_SessionId' => 'Microsoft Internet Information Services 6.0 or later',
      'PHPSESSION' => 'PHP (All Versions)',
      'wiki18_session' => 'MediaWiki 1.8',
      'WebLogicSession' => 'BEA WebLogic (All Versions)',
      'BIGipServer' => 'F5 BIG-IP (All Versions)',
      'SERVERID' => 'HAproxy (All Versions)',
      'SaneID' => 'NetTracker (All Versions)',
      'ssuid'  => 'Vignette (All Versions)',
      'vgnvisitor' => 'Vignette (All Versions)',
      'SESSION_ID' => 'IBM Net.Commerce (All Versions)',
      'NSES40Session' => 'Netscape Enterprise Server 4.0',
      'iPlanetUserId' => 'iPlanet Web Server, SunONE or Java System Application Server 6.x',
      'gx_session_id' => 'Java System Application Server (Unknown Version)',
      'JROUTE' => 'Java System Application Server (Unknown Version)',
      'RMID'   => 'RealMedia OpenAdStream 6.x',
      'CFID'   => 'Coldfusion (Unknown Version)',
      'CFTOKEN' => 'Coldfusion (Unknown Version)',
      'CFGLOBALS' => 'Coldfusion (Unknown Version)',
      'RoxenUserID' => 'Roxen Web Server (Unknown Version)',
      'JServSessionIdroot' => 'ApacheJServer (Unknown Version)',
      'sesessionid' => 'IBM WebSphere Application Server (Unknown Version)',
      'PD-S-SESSION-ID' => 'IBM Tivoli Access Manager WebSeal (part of the IBM TAM for e-business) 5.x, 6.x',
      'PD_STATEFUL_' => 'IBM Tivoli Access Manager WebSeal (part of the IBM TAM for e-business) 5.x, 6.x',
      'WEBTRENDS_ID' => 'WebTrends (Unknown Version)',
      'utm' => 'Google Urchin Tracking Module',
      'utm' => 'Google Urchin Tracking Module',
      'utm' => 'Google Urchin Tracking Module',
      'utm' => 'Google Urchin Tracking Module',
      'sc_id' => 'Omniture',
      's_sq' => 'Omniture',
      's_sess' => 'Omniture',  
      's_vi_' => 'Omniture',
      'Mint' => 'Mint (Unknown Version)',
      'SS_X_CSINTERSESSIONID' => 'OpenMarket/FatWire Content Server',
      'CSINTERSESSIONID' => 'OpenMarket/FatWire Content Server',
      '_sn' => 'Siebel CRM',
      'BCSI-CSC' => 'BlueCoat Proxy',
      'Ltpatoken=' => 'IBM WebSphere Application Server 5.1 and earlier OR Lotus Domino 5.0.x and later',
      'Ltpatoken2=' => 'IBM WebSphere Application Server 5.1 and later', 
      'LtpatokenExpiry' => 'IBM Lotus Domino 5.0.x and later ',
      'LtpatokenUsername' => 'IBM Lotus Domino 5.0.x and later ',
      'DomAuthSessID' => 'Lotus Domino (Unknown Version)',
      'IBM_HTTP_Server' => 'WebSphere Application Server'      
    }
  end
  
  
  #
  # List of interesting header values (fingerprinting)
  #
  def header_list
    {
      'server' => {
                    'Apache/2.2.3 (CentOS)' => 'Apache Version 2.2.3 on CentOS',
                    'Apache/2.2.12 (Ubuntu)' => 'Apache Version 2.2.12 on Ubuntu',
                    'Microsoft-IIS/7.0' => 'Microsoft Internet Information Services 7.0',
                    'Microsoft-IIS/7.5' => 'Microsoft Internet Information Services 7.5',
                    'Apache/1.3.29 (Unix) mod_perl/1.29' => 'Apache on Unix',
                    'Microsoft-IIS/4.0' =>  'Microsoft Internet Information Services 4.0',
                    'Microsoft-IIS/5.0' =>  'Microsoft Internet Information Services 5.0',
                    'Microsoft-IIS/6.0' =>  'Microsoft Internet Information Services 6.0',
                    'Netscape-Enterprise/6.0' => 'Netscape Enterprise 6.0',
                    },
      'x-aspnet-version' => {
                               '1.1.4322'   => 'ASP.NET Framework 1.1',
                               '1.2.30327'  => 'ASP.NET Framework 1.1',
                               '2.0.50215'  => 'ASP.NET Framework 2.0',  
                               '2.0.50727'  => 'ASP.NET Framework 2.0',
                               '4.0.30319'  => 'ASP.NET Framework 4.0',
                               '4.0.21006'  => 'ASP.NET Framework 4.0'
                            }         
    }
  end
  
  
  #
  # When we can match a header with anything in our list,
  # ...print an error
  #
  def print_an_error(str)
    prnt_dbg("Unable to determine platform from: #{str}")
  end
  
  
  #
  # Print a general notification
  #
  def print_notification(obj)
    prnt_gen("Analyzing #{obj}...")
  end
  
  
  #
  # Need to get those cookies in the row array 
  #  
  def print_cookies(cookies)
   cookie_list.each do |key, value|
     if cookies.include?("#{key}")
       row << ["set-cookie", "#{key}", cookie_list["#{key}"]]
     end
   end
   #  If row is populated, we've got some cookies
   if not row.empty?
    prnt_plus("Match made (cookies)")
   else
     print_an_error("cookies")
   end
  end
  
 
  #
  # Check the individual headers
  #
  def header_check(res)
    print_notification("individual headers")    
    res.header.keys.each do |hkey|      
      if header_list.include?(hkey)
        hval = header_list[hkey].include?("#{res.header[hkey]}")
        if (hval)
          rkey = res.header[hkey]
          row << [hkey, "#{rkey}", "#{header_list[hkey][rkey]}"]
          prnt_plus("Match made (#{hkey})")
        else
          print_an_error("#{hkey}")
        end
      end  
    end
    
    if row.empty?
      prnt_err("Unable to passively recon target")
    else
      select(nil,nil,nil, 3)
      print_headers(row)  
    end
    
  end
 
  
  #
  # Print the individual headers which match our lists
  #
  def print_headers(*items)
    list = items.sort
    # Display the commands
      tbl = WXf::WXfui::Console::Prints::PrintTable.new(
        'Justify'  => 4,             
        'Columns' => 
        [
          'Header',
          'Value',
          'Description'
        ])
    list.each do |arry_row| 
      arry_row.each do |name, key, val|  
        tbl.add_ritems([name, key, val])
      end
    end
    tbl.prnt    
    
  end
  
  
  #
  # Kick the module off
  #
  def run
    self.row = []
    print("\n")
    prnt_gen("Sending request to URL: #{rurl}")
    res = mech_req({
      'RURL' => rurl,
      'method' => datahash['METHOD'],
      'REDIRECT' => datahash['REDIRECT']      
    })
    
    if (rce) and (rce_code)
      prnt_err("Received a #{rce_code} error!\n")
    end
    
    if (res) and res.respond_to?('header')
      print_notification("cookies")
      cookies = res.header['set-cookie']
      if not cookies.nil?
        print_cookies(cookies)
      else
        print_an_error("cookies")
      end
      header_check(res)
    end
  end
  
end
