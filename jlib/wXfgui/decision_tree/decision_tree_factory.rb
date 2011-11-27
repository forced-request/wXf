#!/usr/bin/env jruby

require 'java'

module WxfGui
  
  class DecisionTreePackage
          
          attr_accessor :packages
          
          def initialize
              self.packages = []
              file = File.read("#{WXf::PackagesDir}/packages.xml")
              doc = REXML::Document.new(file)
              doc.elements.each("packages/package") do |element|
                   self.packages << element.attributes["name"]
              end
          end
      end
  
  class DecisionTreeItem
         
         attr_accessor :name, :package, :author, :desc, :is_buby, :options
         attr_accessor :required_mods, :optional_mods, :info_file
     
         def initialize(opts={})
             self.name = opts['Name'] || nil
             self.package = opts['Package'] || nil
             self.author = opts['Author']  || nil
             self.desc = opts['Description'] || nil
             self.is_buby = opts['Buby'] || nil
             self.required_mods = opts['Required Modules'] || []
             self.optional_mods = opts['Optional Modules'] || []
             self.info_file = opts['Info File'] || ''
             self.options = WXf::WXfmod_Factory::OptsPlace.new
             add_options
         end
         
         def add_options
           opts ={}
           if !name.nil? and !package.nil?
             opts[self.package.to_s] = self.name.to_s
             self.options.add_opts(opts)
           end
         end
         
         def module_type
          WXf::DT
         end 
  end
           

class DecisionTreeLoader
     
      attr_accessor :dt_modules     
  
       def initialize
          self.dt_modules = []
          load_modules(WXf::ModWorkingDir)
       end
       
       def load_modules(root_dir)
          modules = []  
          Find.find(root_dir) do |m|
              if m =~ /.rb/
                   data = m.match(/decision_tree\/.+rb/)
                   mdata = data.kind_of?(MatchData) ? true : false
                   if mdata
                       modules <<(m)
                   end
              end
          end 
         dt_module_finder(modules)
       end
       
       def dt_module_finder(modules)
         mod = ''
         begin
              modules.each do |m|
                   mod = m
                   conc = ::Module.new
                   conc.module_eval(File.read(m, File.size(m)))
                   inst = conc.const_get('Dti')
                    if (inst)
                         inst_obj = inst.new
                         if inst_obj.respond_to?('module_type')
                              self.dt_modules <<(inst_obj)
                         end 
                    end
              end        
        rescue NameError 
              print("\e[1;31mFailed to load module:\e[0m #{File.basename(mod).gsub!('.rb', '')}\n")
         end
       end
       
   end
   
  class DecisionTreeFactory
    
    attr_accessor :module_hash 
    
       def initialize
           self.module_hash = {}
           dtp = DecisionTreePackage.new
           @packages = dtp.packages
           @dtl = DecisionTreeLoader.new
           init              
       end
       
       def init         
         @packages.uniq!
         if (@dtl)
             @packages.each do |item|
               item_array = []
               @dtl.dt_modules.each do |mod|
                if not mod.respond_to?('start')
                  print("\e[1;31m[wXf error]\e[0m Failed to load module: #{mod.name}\n")
                  return
                end 
                if mod.options.has_key?(item)
                  item_array <<(JCheckBox.new(mod.name, false)) 
                end
                module_hash[item] = item_array
             end
           end
         end
       end 
       
   end
   
end 