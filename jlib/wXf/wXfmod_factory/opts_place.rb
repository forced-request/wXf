
module WXf
module WXfmod_Factory
   
  
   class Opts
     
     
     #
     # Initialize the Opts class
     #
     def initialize(name, vals=[])    
       self.name = name
       self.data_type = data_type
       index_vals(vals)
     end
     
     
     #
     # Perform a sanity check, (make sure stuff exists)
     #    
     def index_vals(vals)
       if vals.kind_of?(Array)
         existence_check(vals)
       end
     end
     
     
     #
     # We perform an existence check on module options
     #
     def existence_check(vals)              
       exists?(vals[0]) ? self.required = vals[0] : self.required = false  
       exists?(vals[1]) ? self.desc = vals[1]  : self.desc = "No Description Available"
       exists?(vals[2]) ? self.data = vals[2]  : self.data = ''
     end
     
     #
     # An existence check
     #
     def exists?(val)
       if val.nil?
         return false
       else
         return true
       end
     end
     
     attr_reader :data, :name, :desc, :required, :data_type
  
     protected
     
     attr_writer :data, :name, :desc, :required, :data_type
     
   end
   
   
  #
  # String class for Opts
  #   
  class OptString < Opts
    
       
    #
    # Initialize the class
    #      
    def initialize(name, vals=[])
      vals[2] =  str_validate(vals)
     super(name, vals)
    end
    
    
    #
    # Validate string value
    #
    def str_validate(vals)
      val_to_s = ''      
      if (vals[2])
        val_to_s = vals[2].to_s
      end
     return val_to_s
    end
    
    #
    # Provides a datatype declaration
    #   
    def data_type
      return 'String'
    end
        
  end
   
   
   
   #
   # Boolean class for Opts
   #  
   class OptBool < Opts
    
     
    #
    # Initialize the class
    #      
    def initialize(name, vals=[])
      vals[2] =  bool_validate(vals)
      super(name, vals)
    end
    
    
    #
    # Validate boolean value
    #
    def bool_validate(vals)
      bool_match = "#{vals[2]}".match(/(true|false)/)
      bool_match_val = bool_match.kind_of?(MatchData) ? bool_match[1] : false
      final_val = bool_match_val == "true" ? true : false
     return final_val
    end
    
    
    #
    # Provides a datatype declaration
    #         
    def data_type
      return 'Boolean'
    end
    
   end
   
   
   
   #
   # Integer class for Opts
   #
   class OptInteger < Opts
   
     #
     # Initialize the class
     #      
     def initialize(name, vals=[])
       vals[2] =  int_validate(vals)
       super(name, vals)
     end
     
     
     #
     # Validate boolean value
     #
     def int_validate(vals)
       final_val = nil
        if vals[2] and vals[2].kind_of?(Integer)
          final_val = vals[2]
        end
       return final_val
     end
     
     
     #
     # Provides a datatype declaration
     #         
     def data_type
       return 'Integer'
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
      opts.each do |key, value|
        self.store(key, value)
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