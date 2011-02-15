# core.rb
# This is our main class, handles all the interactions between the UI components,
# the database, log handler, etc
# 
# created 2010-03-23 by seth
#

require 'wXf/wXflog'

module WXf
module WXfdb


class Core
  
    Major = 1
    Minor = 0
    Release = "-beta"
    Version = "#{Major}.#{Minor}#{Release}"
    
    attr_accessor :db
    attr_accessor :lh
    
    def initialize(dir,debug_level)
      self.lh = WXf::WXflog::Log.new(dir,debug_level)
      self.db = Db.new(dir,self.lh)
    end
    
    def run_exploit(e,p,control)
      case e.type
      when "RFI"
        self.lh.out("Running an RFI exploit (#{e.name})")
        rs = e.run_rfi_exploit(p,lh)
        self.lh.out("Result:\n#{rs}")
      when "XSS"
        self.lh.out("Running an XSS exploit (#{e.name})")
        e.run_xss_exploit(p,lh,control)
      when "SQL"
        self.lh.out("Running an SQLi exploit (#{e.name})")
        e.run_sql_exploit(p)
      end
    end

end
  
       
end
end