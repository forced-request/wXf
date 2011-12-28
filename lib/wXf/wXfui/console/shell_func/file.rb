module WXf
module WXfui
module Console
module Shell_Func
    
  module FileUtility
    

    #
    # Returns an environment variable, based on input
    #
    def self.env_var(var)
      ENV[var]
    end
 
    
    #
    # Returns either the file or a return value of nil for *nix systems
    #
    def self.nix_command(cmd)      
       env_path = env_var('PATH')
       if (cmd and env_path)           
         env_path.split(":").each do |pwdir|
           begin
           arg_verified = "#{pwdir}/" + cmd.to_s           
            if (::File.exists?(arg_verified))
              return arg_verified
            end            
           rescue
           end
         end
         return nil
       end
    end
    
    # Determines the platform
    def self.platform_detection
      platform = ""
      if RUBY_PLATFORM =~ /mswin32/
          platform = "WIN"
      elsif RUBY_PLATFORM =~ /i386-mingw32/
          platform = "WIN"
      else
          platform = "NIX"
      end  
      return platform
    end
    
    #Handles windows system calls
    def self.windows_command(cmd)
      Kernel.system cmd
    end
    
    # Dispatches system call
    def self.command_bin(cmd)
      platform = platform_detection 
      if platform == "NIX"
        nix_command(cmd)
      elsif platform == "WIN"
        windows_command(cmd)
      end   
    end
  

      
end end end end end
