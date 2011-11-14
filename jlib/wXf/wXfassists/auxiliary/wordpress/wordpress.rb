require 'wXf/wXfui'

module WXf
module WXfassists
module Auxiliary
module Wordpress
  
  include WXf::WXfassists::General::MechReq 
  
    #
    # Fetch vulnerable wordpress plugins from db
    #
    def fetch_wp_vuln_plugins
      WXFDB.get_vuln_wordpress_plugins_list
    end
  
    #
    # Fetch all timthumb themes from db
    # 
    def fetch_wp_timthumb
      WXFDB.get_wp_timthumb_list
    end
    
    
    #
    # Fetch all wordpress plugins from db
    #
    def fetch_wp_all_plugins
       WXFDB.get_all_wordpress_plugins_list
    end
    
 
    #
    # Fetch vulnerable wordpress plugins from db by name only
    #
    def fetch_wordpress_vuln_by_name(name) 
      WXFDB.get_wordpress_vuln_by_name(name)
    end
  
  
  # 
  # Enumerate all timthumb vulnerabilities
  #
  def enumerate_timthumb(timeout, prnt)
   rows = []
    vulns = fetch_wp_timthumb
    vulns.each_with_index do |row, idx|
      count = idx + 1
      if (prnt)
        prnt_gen("Requesting #{count} of #{vulns.length}")
      end      
      index = row[0]
      name = row[1]
      path = row[2]
      ref = row[3]       
      url = "#{rurl}/wp-content/themes/#{path}"  
        res = mech_req({
          'method'=> 'GET',
          'RURL'  =>  url,   
          'TIMEOUT' => timeout,
        })

  puts "Sending req to #{url}"
    
      if res and res.respond_to?('code') and res.code == "200"
        row.unshift(res.body.length, res.code.to_i, true)
        rows << row
      elsif rce_code == 403
        row.unshift(rce_code, true)
        rows << row
      elsif res and res.respond_to?('code') and not res.code == "200"
        row.unshift(res.body.length, res.code.to_i, false)
        rows << row
      elsif rce_code and not rce_code == 403
        row.unshift(rce_code, false)
        rows << row
      end
    end
    return rows
  end
    
  #
  # Enumerate site for all vulnerable wordpress plugins
  #
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
  
  
  #
  # Enumerate site for all wordpress plugins
  #
  def enumerate_all_plugins(timeout, prnt)   
    rows = []
    plugins = fetch_wp_all_plugins
    plugins.each_with_index do |row, idx|
      count = idx + 1
      if (prnt)
        prnt_gen("Requesting #{count} of #{plugins.length}")
      end      
      index = row[0]
      name = row[1]
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