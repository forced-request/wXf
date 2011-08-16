#
# Contains the name of the class being stacked and available commands
#

module WXf
module WXfui
module Console
module Processing
  
  class AuxiliaryProcs 
    
    attr_accessor :opts
    
    include WXf::WXfui::Console::Operations::ModuleCommandOperator


    
    def name
      "Auxiliary" 
    end
  
    
    #
    # Available arguments
    #
    def avail_args; {"run" => "Runs the module"}; end
    
        
    #
    # This method determines if an option has been set
    #      
    def check(activity, opt_items)
      return unless activity.respond_to?('datahash')
      val = nil
       opt_items.each do |opt|
         if activity.datahash.has_key?(opt)
            val = activity.datahash[opt]
          else
            val = nil   
          end
        if !val.nil?
          translation(activity, opt, val)
        end
      end
    end  
    
    
    #
    # Method to translates keys to values
    #
    def translation(activity, opt, val=nil)
      inst = val
      self.opts[opt] = val
      case opt
        when 'LFILE'     
          if control.framework.modules.lfile_load_list.has_key?(inst)        
            name = control.framework.modules.lfile_load_list[inst]
            activity.datahash[opt] = name
          end
        when 'RURLS'
          if control.framework.modules.rurls_load_list.has_key?(inst)
            name = control.framework.modules.rurls_load_list[inst]
            activity.datahash[opt] = name
          end
        when 'UA'
          if WXf::UA_MAP.has_key?(inst)
            name = WXf::UA_MAP[inst]
            activity.datahash[opt] = name
          end
       when 'CONTENT'
          if WXf::CONTENT_TYPES.has_key?(inst)
            name = WXf::CONTENT_TYPES[inst]
            activity.datahash[opt] = name
          end
      end           
    end
    
    
    #
    # We need to reset the options appearance (think - show options)
    #
    def reset(activity, opt_items)
      return unless activity.respond_to?('datahash')
      opt_items.each do |opt|
        if activity.datahash.has_key?(opt) and self.opts.has_key?(opt)
          activity.datahash[opt] = self.opts[opt]
        end
      end
    end
        
    #
    # Checks and error handling, nm at the moment tho :-)
    #
    def arg_run(*cmd)
      self.opts = {}
      check(activity, ['LFILE','UA', 'CONTENT', 'RURLS'])
        begin
          activity.run
        rescue => $!
          print("The following error occurred: #{$!}" + "\n")
         reset(activity, ['LFILE','UA', 'CONTENT', 'RURLS'])
        end
      reset(activity,['LFILE','UA', 'CONTENT', 'RURLS'])     
    end  
     
  end
  
end end end end    