module WXf
module WXfconductors
  
  class XmlRpc_Conductor
    
    attr_accessor :options, :desc
    
    def initialize(control)
      @control = control
      init_opts
    end
    
    def init_opts
      # xmlrpc options that the user will set
      self.options = {
          "USER" => "",
          "PASS" => "",
          "PORT" => 9000,
      }
      # description of each option, shown to user
      self.desc = {
          "USER" => "set the username",
          "PASS" => "set the password",
          "PORT" => "Port to listen on",
      }
    end
    
    def usage
      # Display the commands
      tbl = WXf::WXfui::Console::Prints::PrintTable.new(
      'Output' => @control.output,
      'Title' => 'XML-RPC Server Options',
      'Justify'  => 4,             
      'Columns' => 
      [
        'Name',
        'Current Setting',
        'Description',                     
      ])
     
      self.options.each { |k,v|
        if (!v)
          v = ""
        end
        tbl.add_ritems([k.to_s,v.to_s, self.desc[k].to_s ])
      }
     tbl.prnt
    end

    
    #
    # Defines the type of module
    #
    def type
      XMLRPC
    end
    
  end 
  
end end 