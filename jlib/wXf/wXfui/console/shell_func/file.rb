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
    # Returns either the file or a return value of nil
    #
    def self.command_bin(cmd)      
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
       

      
end end end end end
