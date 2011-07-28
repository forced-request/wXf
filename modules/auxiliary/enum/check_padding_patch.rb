class WebXploit < WXf::WXfmod_Factory::Auxiliary   
  
  def initialize
    super(

            'Name'        => 'MS10-070 "Oracle Padding Vuln" Check',
            'Description' => %q{
         This is a port of the handful of Oracle Padding Vuln scripts that
         check if the MS10-070 patch has been applied using ScriptResource or
         WebResource as an indicator. 
                            
               This is not original work. Creds to Rizzo and Duong original
               research on the topic, Brian Holyfield's padbuster, and
               Bernardo Damele for the python port. 
            },
            'References'  =>
             [
                [ 'URL', 'https://www.gdssecurity.com/l/t/d.php?k=PadBuster' ],
                [ 'URL', 'http://twitter.com/julianor/status/26419702099' ],
                [ 'URL', 'http://bernardodamele.blogspot.com/2011/04/ms10-070-padding-oracle-applied-to-net.html' ],
             ],
            'Author'      => [ 'willis',],
            'License'     => WXF_LICENSE
  
    )
          
      init_opts([
          OptString.new('D', [true, 'The required d parameter from either WebResource or ScriptResource', "***"]),
         ])
  end
  
def run
   d = datahash['D']
   
   #first we need to replace some of the characters
   output = d.tr('-_','+/')

   last = output.split('').last
   add_on = "=" * Integer(last)
   output = output.chop + add_on

   #base64 decode the string
   decoded = output.unpack('m')[0]
   
   #if length mod 8 is zero, you is vulnerable
   if ((decoded.length % 8) == 0)
      prnt_plus("Vulnerable! The patch has not been applied.")
   else
      prnt_plus("Not Vulnerable. The patch has been applied.")
   end
  
end

end
