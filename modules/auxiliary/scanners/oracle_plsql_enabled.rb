class WebXploit < WXf::WXfmod_Factory::Auxiliary

  include WXf::WXfassists::General::MechReq
  
  def initialize
    super(
      'Name'        => 'Oracle Application PL/SQL Gateway Detection',
      'Version'     => '1.0',
      'Description' => 'Checks to see if PL/SQL is enabled. If the server responds with a 200 OK response for the 
                        first request ("null") and a 404 Not Found for the second (something random) then it indicates 
                        that the server is running the PL/SQL Gateway. Pay careful attention to the /\'s in URIPATH and DAD',
      'Author'      => 'CG' ,
      'License'     => WXF_LICENSE,
      'References'  =>
        [
          [ 'URL', 'http://www.owasp.org/index.php/Testing_for_Oracle' ]
        ]
    )
    init_opts(
      [
        OptString.new('URIPATH', [ true,  "The URI PATH", '/pls/']),
        OptString.new('DAD', [ true,  "The Database Access Descriptor", 'portal/'])
      ])
  end

  def run

    check1 = "null"
    word = "completelyRandom"
    check2 = word.split("").sort_by{rand}.join
     
    nullcheck = ''
    nonnullcheck = ''

    begin 
      path = datahash['URIPATH']
      dad = datahash['DAD']
      
      prnt_gen("Sending requests to #{rurl}#{path}#{dad}\n")
      
      res = mech_req({
        'RURL'          => rurl + path + dad + check1, 
        'method'       => 'GET',
        'PROXY_ADDR' => proxya,
        'PROXY_PORT' => proxyp,
        'REDIRECT'   => 'false'       
       })

      if (res.nil?)
        prnt_err("No response for #{rurl} #{check1}")
      end
      
      if (res) and (res.respond_to?('code')) and (res.code == '200')
        prnt_gen("Received #{res.code} for #{check1}")
        nullcheck << res.code.to_s
      end
      
      if (res) and (res.respond_to?('code')) and (res.code == '302' or res.code == '301')
        prnt_gen("Redirect to #{res.header['location']}")
        nullcheck << res.code.to_s
      end
       
      if (rce)
        rce_code = rce.to_s.match(/\d{3}/)
        prnt_gen("Received #{rce_code[0]} for #{check1}")       
        nullcheck << "#{rce_code[0]}"
      end

      res = mech_req({
        'RURL' => rurl + path + dad + check2,
        'method'       => 'GET',
        'PROXY_ADDR' => proxya,
        'PROXY_PORT' => proxyp,
        'REDIRECT'   => 'false' 
      })

      if (res.nil?)
        prnt_err("No response for #{rurl} #{check2}")
      end
      
       if (res) and (res.respond_to?('code')) and (res and res.code == '200')
        prnt_gen("Received #{res.code} for #{check2}")
        nonnullcheck << res.code.to_s
       end
       
       if (res) and (res.respond_to?('code')) and (res.code == '302' or res.code == '301')
        prnt_gen("Redirect to #{res.header['location']}")
        nonnullcheck << res.code.to_s
       end 
       
       if (rce)
        rce_code = rce.to_s.match(/\d{3}/)
        prnt_gen("Received #{rce_code[0]} for #{check2}")
        nonnullcheck <<  "#{rce_code[0]}"
          #''
      end
      
      #need to do the null/nonnull shiz here to say if pl/sql is enabled or not
      if (nullcheck == "200" and nonnullcheck == "404")
        prnt_plus("#{rurl}#{path}#{dad} PL/SQL Gateway appears to be running!")
      else
        prnt_err("PL/SQL gateway is not running")
      end
    end
  end 
end
