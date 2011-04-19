
class WebXploit < WXf::WXfmod_Factory::Auxiliary

  include WXf::WXfassists::General::MechReq

  def initialize
    super(
      'Name'        => 'Oracle Application Server Detection',
      'Version'     => '1.0',
      'Description' => 'Checks the server headers for common Oracle Application Server (PL/SQL Gateway) Headers.  
                        You may want to append /apex/ to the URL; http://example.com/apex/ as a check for Oracle Application Express Servers.',
      'Author'      => 'CG' ,
      'License'     => WXF_LICENSE,
      'References'  =>
        [
          [ 'URL', 'http://www.owasp.org/index.php/Testing_for_Oracle' ]
        ]
    )
   
  end

  def run
    dradis = WXf::WXflog::DradisLog.new({
          'Name' => "version_scan_of_#{rurl}",
          'Filename' => 'oracle_version_scanner.xml'
    })

    begin 

      res = mech_req({
        'RURL'   => rurl, 
        'method' => 'GET',
        'DEBUG'      => 'log',
        'PROXY_ADDR' => proxya,
        'PROXY_PORT' => proxyp
      })

      if (res) and (res.header['server'])
        if res.header['server'] =~ /Oracle/ or res.header['server'] =~ /Oracle HTTP Server/ or res.header['server'] =~ /Oracle-Application-Server/ or res.header['server'] =~ /Oracle_Web_Listener/ or res.header['server'] =~ /Oracle9iAS/ or res.header['server'] =~ /mod_plsql/ or res.header['server'] =~ /Oracle XML DB/ or res.header['server'] =~ /Apache\/1.3.12 \(Win32\) ApacheJServ\/1.1 mod_ssl\/2.6.4 OpenSSL\/0.9.5a mod_perl\/1.22/
          prnt_gen("Oracle Application Server Found!")
          prnt_gen("#{rurl} is running #{res.header['server']}")
          dradis.add_ritems([res.header, req_seq , res.body]) 
        else
          prnt_gen("#{rurl}") #debug
          prnt_gen("#{res.header['server']}") #debug
        end
      end
    end
  dradis.log 
 end  
end

#Oracle 8.1.7 
#Server: Apache/1.3.12 (Win32) ApacheJServ/1.1 mod_ssl/2.6.4 OpenSSL/0.9.5a mod_perl/1.22

#Oracle Application Server Forms and Reports Services 10.1.2.0.2
#Server: Oracle-Application-Server-10g/10.1.2.0.2 Oracle-HTTP-Server OracleAS-Web-Cache-10g/10.1.2.0.2 (G;max-age=0+0;age=0;ecid=3285557964107,0)

#Oracle Database 9i
#Server: Oracle HTTP Server Powered by Apache/1.3.22 (Win32) mod_plsql/3.0.9.8.3b mod_ssl/2.8.5 OpenSSL/0.9.6b mod_fastcgi/2.2.12 mod_oprocmgr/1.0 mod_perl/1.25

#Oracle App Server 10.1.2.0
#Server: Oracle-Application-Server-10g/10.1.2.0.0 Oracle-HTTP-Server OracleAS-Web-Cache-10g/10.1.2.0.0 (G;max-age=0+0;age=0;ecid=3710918334042,0)
