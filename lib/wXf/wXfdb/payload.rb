# payload.rb
# Part of the core module, holds all of the data for the
# payload to be used with an exploit
# 
# created 2010-03-29 by seth
#

require 'base64'

module WXf
module WXfdb


class Payload
  
  attr_accessor :id, :name, :desc, :type, :content, :lang, :required, :optional, :options, :url, :params, :requires_webserver
 
  def initialize(payload)
    (self.id, self.name, self.desc, self.type, self.content, self.lang, val, self.url, pars, self.requires_webserver) = payload
    values = eval("#{val}")
    self.params = eval("#{pars}")
    self.required = values[:required]
    self.optional = values[:optional]
    self.options = {}
    self.options.merge!(self.required)
    self.options.merge!(self.optional)    
  end
  
  
  
  def get_rfi_payload(method)
    case method
        when "GET", "POST"
          url = self.options['LURL']
        when "PUT"
        end
        return url
  end
  
  # TODO - This functions needs to be dynamic (like above).  These hardcoded values are going to hurt us 
  # in the long run.
  def get_rfi_payload_params
    if (self.params)
      params = self.params
    end  
      encode = self.options['ENCODE']
    if encode == true
      params['e'] = "T"
      params['c'] = Base64.encode64(self.options['CMD']).chomp      
    else
      params['e'] = "F"
      params['c'] = self.options['CMD']
    end
    return params
  end
  
  def get_rfi_payload_result(input)
    if self.options['ENCODE'] == true
      return Base64.decode64(input)
    else
      return input
    end
  end
 
  def get_xss_payload(method)
    lurl = self.options['LURL']
       
    if self.requires_webserver == "1"
      servlet = Base64.encode64(self.name).gsub(/(=|\r|\n)/,"")
      puts "Using path: #{servlet}"
      if ( lurl !~ /#{servlet}/)
        larry = lurl.split("/")
        larry.insert(3,servlet)
        lurl = larry.join("/")
        self.options['LURL'] = lurl
      end
    else
      #puts "Doesn't require a webserver"
    end
    
    case method
    when "GET","POST"
      if ( lurl )
        return lurl
      end
      if ( content.length > 0 )
        while content.match(/<#>(\w+)<%>?/)
          x = content.match(/<#>(\w+)<%>?/)
          if self.options.has_key?(x[1])
            k = x[1]
            content.gsub!(x[0],"#{self.options[k]}")
          else
            content.sub!(x[0],"FAIL")
          end
        end
        return content
      end
    
    when "PUT"
    end

    return nil
  end
  
def get_xss_payload_params
  return self.params
end
 


#
# Modified to give a more compact display options
#    
def dis_required_opts
   # Display the commands
   tbl = WXf::WXfui::Console::Prints::PrintTable.new(
   'Justify'  => 4,             
   'Columns' => 
   [
   'Name',
   'Current Setting',
   'Required',
   'Description',
   ])
               
  self.required.each { |k,v|
  tbl.add_ritems([k.to_s,v.to_s, "yes"])
                     }
                     
  self.optional.each { |k,v|
  tbl.add_ritems([k.to_s,v.to_s, "no"])
   }
  tbl.prnt             
   
end


  
    def usage
       
        $stderr.puts("Payload (#{self.name}) options:")
        dis_required_opts
       
    end
  
  


end
  
       
end
end