class WebXploit < WXf::WXfmod_Factory::Auxiliary   
  
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
             ],
            'Author'      => [ 'willis',],
            'License'     => WXF_LICENSE
  
    )
          
      init_opts([
          OptString.new('REDIRECT', [false, 'Set to false if you prefer the 301/302 not be followed ', true]),
          OptString.new('METHOD', [false, 'By default the value is GET, changed to POST if you choose', "GET"])
         ])
  end
  
  def cookie_list 
    
    {
      'JSESSIONID'    => 'J2EE Application server',
      'ASPSESSIONID'  => 'Microsoft Internet Information Services 5.0',
      'ASP.NET_SessionId' => 'Microsoft Internet Information Services 6.0',
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
    }
  end
  
  def print_an_error(obj)
    prnt_err("Unable to determine platform from: #{obj}\n")
  end
  
  def print_notification(obj)
    prnt_gen("Analyzing #{obj}...")
  end
    
  def print_cookies(cookies)
   c_arry = []
   cookie_list.each do |key, value|
     if cookies.include?("#{key}")
       c_arry.push(cookie_list["#{key}"])
     end
   end
   
   if not (c_arry.empty?)
     prnt_gen("Detected the following platform specific cookies:\n")
     prnt_plus("#{c_arry}")
     print("\n")
   else
     print_an_error("cookies")
   end
  end
  
  def run
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
    end
  end
  
end
