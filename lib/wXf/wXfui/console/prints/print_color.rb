module WXf
module WXfui
module Console
module Prints
  
  
  module PrintColor
    
    #
    # Ken's Comment - I basically hate this re-work in the code, 
    # ...I need to invoke metaprogramming techniques.
    # ...will modify when refactoring. Low-Priority at the moment.
    #
    
    # pr_based means that it is a prompt based color change

    def red(str, pr_based=nil) 
      colorize(str, "\e[1m\e[31m", pr_based)         
    end  
   
    
    def blink(str, pr_based=nil)
      colorize(str, "\e[5m", pr_based)
    end
    
    def green(str, pr_based=nil)
      colorize(str, "\e[1m\e[32m")
    end
    
    def clear(str, pr_based=nil)
      colorize(str, "\e[0m", pr_based)
    end
    
      
    def dark_green(str, pr_based=nil)
      colorize(str, "\e[32m", pr_based)
    end
      
    def yellow(str, pr_based=nil)
      colorize(str, "\e[1m\e[33m", pr_based)
    end
      
    def underline(str, pr_based=nil)
       colorize(str, "\e[4m", pr_based)
    end
      
    def blue(str, pr_based=nil)
      colorize(str, "\e[1m\e[34m", pr_based) 
    end
    
    def dark_blue(str, pr_based=nil)
      colorize(str, "\e[34m", pr_based)
    end
    def purple(str, pr_based=nil)
      colorize(str, "\e[1m\e[35m", pr_based) 
    end
    
    def colorize(text, color_code, pr_based=nil)  
       text_line = "#{text.dup}"
       if (pr_based == true)
        pre = "\x01"
        post = "\x02"
       else
         pre = ''
         post = ''
       end   
       text_line.gsub!("#{text}", pre + "#{color_code}#{text}\e[0m" + post)
       text_line 
   rescue
     ''+"#{color_code}#{text}\e[0m" +''
    end
  
  

  end
  
  
  
end end end end