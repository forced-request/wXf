
class WebXploit < WXf::WXfmod_Factory::Auxiliary

def initialize


  super(
        
        
         'Name'        => 'Sample',
         'Version'     => '$Revision:$',
         'Description' => %q{
          Sample Module
                          },
         'References'  =>
          [
             [ 'URL', 'http://www.example.com' ],
             [ 'URL', 'http://www.another-example.com']  
          ],
         'Author'      => [ 'CKTRICKY' ],
         'License'     => WXF_LICENSE
        )
        
        init_opts([
          OptString.new('SAMPLE', [true, "Description of this option", "Default"])
         ])
         
    end

def run

puts "I'm supposed to do something in this method"

end

end
