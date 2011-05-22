
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
       index_vals(vals)
     end
     
     
     #
     #
     #    
     def index_vals(vals)
       if vals.kind_of?(Array)
         existence_check(vals)
       end
     end
     
     #
     #
     #
     def existence_check(vals)
              
       if exists?(vals[0])
         self.required = vals[0]
       else
         self.required = false  
       end
       
       if exists?(vals[1])
         self.desc = vals[1]
       else
         self.desc = "No Description Available"
       end
       
       if exists?(vals[2])
         self.data = vals[2]
       else
         self.data = ''
       end
       
     end
     
     #
     #
     #
     def exists?(val)
       if val.nil?
         return false
       else
         return true
       end
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
    attr_accessor :sarr
     
     def initialize(opts={})
       init_sarr
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
     # Initiates an empty array
     #
     def init_sarr
       self.sarr = []
     end
     
     
     #
     # Sorts self
     #
     def perform_sort
       self.sarr = self.sort
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
       perform_sort
     
     rescue => $!
     print(" #{$!}\n")  
       
     end
      
     #
     # Method was added because sometimes you just need to be
     # ...able to delete an option. Such is the case when we want
     # only RURLS and not RURL, etc.
     #
     def delete_option(opts)
       self.sarr.each_with_index do |opt, idx|
         name, option = opt
         if name == opts
           self.sarr.delete_at(idx.to_i)
           self.delete(opts)
         end         
       end    
     end
     
    end
    
end end       