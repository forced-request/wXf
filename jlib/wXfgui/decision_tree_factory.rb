#!/usr/bin/env jruby



   class DecisionTreePackageFactory
        
        def intialize(opts={})
            self.name = opts[name] || "No Name provided"
            self.items = 
            self.precedence 
        end
    end

    class DecisionTreeItemFactory
    
        def initialize(opts={})
            self.name
            self.package
            self.author
            self.desc
            self.is_buby
        end
    
    end
    
    class DecisionTreeFactory
        
        
    end

