require 'wXf/wXfui'

module WXf
module WXfassists
module Auxiliary
module Wordpress
  
  include WXf::WXfassists::General::MechReq 
  
  def fetch_wp_vuln_plugins
    WXFDB.get_vuln_wordpress_plugins_list
  end
  
  def enumerate_vuln_plugins(timeout, prnt)
   
    rows = []
    vulns = fetch_wp_vuln_plugins
    vulns.each_with_index do |row, idx|
      count = idx + 1
      if (prnt)
        prnt_gen("Requesting #{count} of #{vulns.length}")
      end
      
      index = row[0]
      name = row[1]
      vuln = row[2]
      ref = row[3]   
    
      url = "#{rurl}/wp-content/plugins/#{name}"
    
      
        res = mech_req({
          'method'=> 'GET',
          'RURL'  =>  url,   
          'TIMEOUT' => timeout,
        })
    
    
      if res and res.respond_to?('code') and res.code == "200"
        row.unshift(res.code.to_i, true)
        rows << row
      elsif rce_code == 403
        row.unshift(rce_code, true)
        rows << row
      elsif res and res.respond_to?('code') and not res.code == "200"
        row.unshift(res.code.to_i, false)
        rows << row
      elsif rce_code and not rce_code == 403
        row.unshift(rce_code, false)
        rows << row
      end
    end
    return rows
  end
  
end 

end end end