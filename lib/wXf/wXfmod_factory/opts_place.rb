
module WXf
module WXfmod_Factory
   
  # 
  # TODO: Add in validation checks, this will need to occur eventually
  # ...for now we haven't built this in because it works as is although not
  # fail proof. 
  #
  
   class Opts
     
     def initialize(name, vals=[])
    
     self.name = name
     self.required = vals[0]
     self.desc = vals[1]
     self.data = vals[2]
     end
    
     attr_reader :data, :name, :desc, :required
  
     protected
     
     attr_writer :data, :name, :desc, :required
     
   end
   
  class OptString < Opts
    def datatype
      return 'string'
    end
  end
   
   
   
   #
   # Boolean class for Opts
   #  
   class OptBool < Opts       
       def data_type
         return 'bool'
       end
   end
   
   
   
   #
   # Integer class for Opts
   #
   class OptInteger < Opts
     
     def data_type
       return 'integer'
     end
     
   end
  
   
   #
   #
   # 
   class OptsPlace < Hash
    attr_accessor :sorted
     
     def initialize(opts={})
       self.sorted = []
     end
     
      
      #
      # First method called by mod_factory to initiate the process of 
      # ...adding options
      # 
      def add_opts(opts)
        
        if opts.kind_of?(Array)
          add_opts_array(opts)
        end
        
        if opts.kind_of?(Hash)
        add_opts_hash(opts)
        end
      end
         
      
     #
     # If the option is an array type, this method is
     # ...is called to initiate the next steps.
     # 
     def add_opts_array(opts)
        opts.each do |opt|
         add_sin_opt(opt)
        end
       
     end
      
      
      #
      # If the option is a hash type, this method is 
      # ...called to begin the next step.
      #
      def add_opts_hash(opts)
       opts.each_pair do |name, opt|
       add_sin_opt(opt, name)
      end
     end  
     
     
     #
     # This method adds a single option. Broken down by the previous methods
     # ...and makes the final decision on storing option data.
     #
     def add_sin_opt(opt, name=nil)
       
       if opt.kind_of?(Array)
         opt = opt.shift.new(name, opt)
       elsif !opt.kind_of?(Opts)
         raise ArgumentError,
                "Option (#{name}) was not in a recognized format.", caller
       end
       
       self.store(opt.name, opt)
       self.sorted = self.sort
     
     rescue => $!
     print(" #{$!}\n")  
       
     end
      
    end
    
end end       