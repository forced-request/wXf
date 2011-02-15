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



#TODO: We want to create three various forms of output. We want to give the developer
# ...the option of setting HTML, Plain-Text or XML (Dradis).
# The method HTML will require that we check first to see if any extension exists. If is does, we then must check if it matches ".html"
# ...if it does not match ".html" then we will go ahead and append that value.
# XML, next on the agenda after sorting out the regexp involved in the .html check, is to move on to the dradis output. We will want to go ahead and determine
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
