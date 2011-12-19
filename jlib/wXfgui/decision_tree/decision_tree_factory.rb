#!/usr/bin/env jruby

require 'java'

module WxfGui
  
  
  #
  # This parses the package.xml file to determine what packages are available
  # ...and what order they should be in
  #
  class DecisionTreePackage
          
          # Packages are our where decision tree items will fall
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
  
  
  #
  # When individual DT items are loaded, we need their specific values, this handles that
  #
  class DecisionTreeItem
         
         # These are necessary options to expose for each decision tree item
         attr_accessor :name, :package, :author, :desc, :is_buby, :options
         attr_accessor :required_modules, :optional_modules, :info_file, :path
     
         def initialize(opts={})
             self.name = opts['Name'] || nil
             self.package = opts['Package'] || nil
             self.author = opts['Author']  || nil
             self.desc = opts['Description'] || nil
             self.is_buby = opts['Buby'] || nil
             self.required_modules = opts['Required Modules'] || ''
             self.optional_modules = opts['Optional Modules'] || ''
             self.info_file = opts['Info File'] || ''            
             self.options = WXf::WXfmod_Factory::OptsPlace.new
             add_options
         end
         
         
         #
         # We are using the Options hash to store a record of both our package
         # ...and name
         #
         def add_options
           opts ={}
           if !name.nil? and !package.nil?
             opts[self.package.to_s] = self.name.to_s
             self.options.add_opts(opts)
           end
         end
         
         
         #
         # Need a type so we can be sure what we're invoking
         #
         def module_type
          WXf::DT
         end
         
         
         #
         # Make path is just a super easy way to determine where
         # ...in the modules path this module is located
         #
         def make_path(p)
           
           if File.exists?(p)
             self.path = p.gsub!("#{WXf::ModWorkingDir}", '')
           end
         end
  end
           

  #
  #  Loads decision tree items and instantiates them
  #
  class DecisionTreeLoader
      
      # An array containing each of the decisiont tree modules
      attr_accessor :dt_modules     
       
       
       #
       # Kick off the other methods
       # 
       def initialize
          self.dt_modules = []
          dt_module_finder(WXf::ModWorkingDir)
       end
       
       
       #
       # Finds prospective DT modules
       #
       def dt_module_finder(root_dir)
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
         load_modules(modules)
       end
       
       
       #
       # Loads the modules
       #
       def load_modules(modules)
          mod = ''
          begin
            modules.each do |m|
              mod = m
              conc = ::Module.new
              conc.module_eval(File.read(m, File.size(m)))
              inst = conc.const_get('Dti')
              if (inst)
                  inst_obj = inst.new
                  if inst_obj.respond_to?('module_type') and inst_obj.module_type ==  WXf::DT
                    inst_obj.make_path(m)
                    self.dt_modules <<(inst_obj)
                  end 
              end
            end 
          rescue NameError 
            print("\e[1;31mFailed to load module:\e[0m #{File.basename(mod).gsub!('.rb', '')}\n")
          end
       end
       
   end
   
  
  #
  # Kicks off the entire process of loading up decision tree items
  #
  class DecisionTreeFactory
    
    # Exposing the dt_modules and the module hash
    attr_accessor :module_hash, :dt_modules 
       
       
       #
       # Dreate a module hash to store instantiated modules, that's
       # ...the biggest thing here
       #
       def initialize
           self.module_hash = {}
           dtp = DecisionTreePackage.new
           @packages = dtp.packages
           @dtl = DecisionTreeLoader.new
           self.dt_modules = @dtl.dt_modules
           init              
       end
       
       
       #
       # Removes redundant package names, assigns a package as the key (module_hash)
       # ...and modules as the values
       #
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