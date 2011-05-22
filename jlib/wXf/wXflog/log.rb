# log.rb
# Log handling routines
#
# created 2010-03-23 by seth

module WXf
module WXflog

  class Log
    # Set the debug level when the log handler is created, 
     # anything with a level equal or less than the
     # set level will be output
     def initialize(dir,level)
       @debugfile = "#{dir}/log/wXf-debug.log"
       @errorfile = "#{dir}/log/wXf-error.log"
       @level = level
     end
     
     # See the above message on debug levels, if it passes
     # the test, all messages go to @debugfile
     def debug(debug_level,msg)
       if (debug_level <= @level)
         f = File.new(@debugfile,"a")
         f.puts "[#{Time.now}] #{msg}"
         f.close
       end
     end
     
     # The log function outputs the given message to the screen 
     # and logs it to @debugfile
     def log(msg)
       self.out(msg)
       self.debug(@level,msg)
     end

    # The out function just puts the stream out to the screen, no logging
    def out(msg)
      puts "[wXf] #{msg}"
    end
          
     # Anything sent to error goes to @errorfile
     def error(msg)
       f = File.new(@errorfile,"a")
       f.puts "[wXf #{Time.now}] #{msg}"
       f.close
     end
  
end

class DradisLog
  attr_accessor :rows, :filename, :file, :name
  
  def initialize(opts={})
    self.rows = []
    self.name = opts['Name'] || 'wXf results'  
    self.filename = opts['Filename'] || 'wxf_dradis.xml'
    log_file = "#{LogsDir}#{filename}"
    if File.exists?(log_file)
      File.delete(log_file)
    end
    self.file = File.new(log_file, "a")
  end
  
  
  #
  # First method called, adds each row as an array with its own index
  #
  def add_ritems(items)
    self.rows << items
  end 
   
  
  #
  # Header string, required once within the xml doc
  #
  def header_str 
    time = "#{Time.now}"   
    str = ''
    str << '<?xml version="1.1"?>' + "\n"
    str << '<!DOCTYPE contentdata ['  + "\n"
    str << '<!ELEMENT contentdata (content*)>' + "\n"
    str << '<!ATTLIST contentdata wxfVersion CDATA "">' + "\n"
    str << '<!ATTLIST contentdata exportTime CDATA "">' + "\n"
    str << '<!ELEMENT contentdata (time, name, headers, body*)>' + "\n"
    str << '<!ELEMENT time (#PCDATA)>' + "\n"
    str << '<!ELEMENT name (#PCDATA)>' + "\n"
    str << '<!ELEMENT headers (#PCDATA)>' + "\n"
    str << '<!ELEMENT request (#PCDATA)>'  + "\n"
    str << '<!ELEMENT bodyofmessage (#PCDATA)>' + "\n"
    str << ']>' + "\n"
    str << '<contentdata wxfVersion="1.0b" exportTime=' + '"' + time + '"' + ">\n"    
    return str
  end
  
  
  #
  # Headers in responses, hash iterated thru and
  # ...put on a string :-)
  #
  def resp_header_str(resp_header)
    str = ''
    str << '<headers><![CDATA[' + "\n"
    resp_header.each do |k,v|
      str << "#{k}: #{v}" + "\n"
    end
    str << ']]></headers>' + "\n"
   return str
  end
  
  
  #
  # Request encapsulated and stringified
  #
  def request_str(request)
    str = ''
    str << '<request><![CDATA['
    str << "#{request}"
    str << ']]></request>'
    return str
  end
  
  
  #
  # Response body, encapsulated, stringified
  #
  def resp_body_str(resp_body)
    resp_body.gsub!('<![CDATA[', '')
    resp_body.gsub!(']]>', '')
    str = ''
    str << '<bodyofmessage><![CDATA[' + "\n"
    str << "#{resp_body}" + "\n"
    str <<  ']]></bodyofmessage>' + "\n"
   return str
  end
  
  
  #
  # This signifies the end of the xml body, goes
  # ...into the xml doc only once.
  #
  def footer_str
    str = ''   
    str << '</contentdata>'  
   return str
  end
  
  
  #
  # Primary data set put into a xml node
  #
  def data_to_str(arry, idx)
    time = "#{Time.now}"
    resp_header = arry[0] || {} 
    request     = arry[1] || ''
    resp_body   = arry[2] || ''
    
    str = ''
    str << '<content>' + "\n"
    str << '<time>' + time + '</time>' + "\n"
    str << '<name>' + "#{idx}_#{self.name}" + '</name>' + "\n"    
    str << resp_header_str(resp_header)
    str << request_str(request)
    str << resp_body_str(resp_body) 
    str << '</content>' + "\n"
   return str
  end
  
  #
  # Method to log a single request instance into dradis
  # ...format
  #
  def log
    str = ''
    str << header_str
      self.rows.each_with_index do |items, idx|
        str << data_to_str(items,idx)
      end
    str << footer_str
    self.file.puts(str)
    self.file.close  
  end
end  


#TODO: We want to create three various forms of output. We want to give the developer
# ...the option of setting HTML, Plain-Text or XML (Dradis).
# The method HTML will require that we check first to see if any extension exists. 
# If is does, we then must check if it matches ".html"
# ...if it does not match ".html" then we will go ahead and append that value.
# XML, next on the agenda after sorting out the regexp involved in the .html check, 
# ...is to move on to the dradis output. We will want to go ahead and determine
# a way to store the content in a fashion that will work for any Dradis plugin. 
# Also, we need make it possible to view the logfile at runtime. 


module ModuleLogger
  
  
  #
  # This method can be called directly by anything that includes the 
  # ...ModuleLogger module
  #  
  def output(str, file, format=nil)
    case format
    when "xml"
      log_xml(str, file)
    when "html"
      log_html(str, file)
    else
      log_raw(str, file)
    end  
  end
 
  
  #
  # Used Rubular to test, site rocks!
  # This method just checks if the extension matches html or xml.
  # 
  def ext_check?(file)
   if "#{file}".match(/(.*?)\.+(html|xml)$/)
     return true
   else
     return false
   end
  end
  
  
  #
  # This is for logging HTML. Right now it doesn't check content
  # ...all it does is check the file extension
  #
  def log_html(str, file)
    if (ext_check?(file) == true)
      f = File.new("#{LogsDir}" + "#{file}", "a")
    else
     f = File.new("#{LogsDir}" + "#{file}"+".html", "a")
    end
     f.puts("#{str}")
     f.close   
  end
  
  
  #
  # This is for logging XML. Right now it doesn't check content
  # ...all it does is check the file extension
  #
  def log_xml(str, file)
    if (ext_check?(file) == true)
      f = File.new("#{LogsDir}" + "#{file}", "a")
    else
     f = File.new("#{LogsDir}" + "#{file}"+".xml", "a")
    end
     f.puts("#{str}")
     f.close   
  end
  
  
  #
  # This is for putting content to a file regardless of content or extension
  #
  def log_raw(str, file)
    f = File.new("#{LogsDir}" + "#{file}", "a")
    f.puts("#{str}")
    f.close      
  end
  
  
end

end
end
