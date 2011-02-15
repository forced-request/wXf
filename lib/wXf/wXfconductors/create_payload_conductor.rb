module WXf
module WXfconductors
  
  class Create_Payload_Conductor
     
     attr_accessor :options, :desc
     
     def initialize(control)
          
       self.options = {
         'NAME'   => "payload",
         'DESC'   => "description",
         'TYPE'   => "XSS",
         'LANG'   => "JS",
         'CONTENT' => '<script>alert("<#>TXT<%>")</script>',
         'URL'    => "http://127.0.0.1:8080/path/index.html",
         'PARAMS' => '{ "p1" => "v1", "p2" => "<#>VAR<%>" }',
         'VALUES' => '{ :required => { "LURL"=>"http://127.0.0.1:8080/path/index.html" }, :optional => { "VALUE"=> "value" }',
         'WEBSERVER_REQUIRED' => '0'
       }
       
       self.desc = {
               'NAME'   => "name of the payload",
               'DESC'   => "full description",
               'TYPE'   => "type of payload (RFI/XSS/CSRF)",
               'LANG'   => "language (PHP/JS/CFM)",
               'CONTENT' => "content to include in the payload (GET/POST/PUT)",
               'URL'    => "url to access the payload",
               'PARAMS' => 'parameters to append to the URL or in the POST body of the exploi tdefined as a ruby hash, use <#>VAR<%> for variable options',
               'VALUES' => 'required and optional variables defined as a ruby hash, any <#>VAR<%> values must be defined in this hash',
               'WEBSERVER_REQUIRED' => '1 = startup a webserver hosting this payload, 0 = no webserver required'
       }
    
     end  
     
     def type
       CREATE_PAYLOAD
     end
     
     def dis_opts
      # Display the commands
      tbl = WXf::WXfui::Console::Prints::PrintTable.new(
      'Justify'  => 4,             
      'Columns' => 
      [
      'Name',
      'Current Setting'
      ])
      
      self.options.each { |k,v|
      tbl.add_ritems([k.to_s,v.to_s])
                         }
      tbl.prnt
      end
      
      def usage
        $stderr.puts("\n"+"Payload options:")
        dis_opts  
      end
      
   end
   
end end