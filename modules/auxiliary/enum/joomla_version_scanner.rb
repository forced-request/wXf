class WebXploit < WXf::WXfmod_Factory::Auxiliary   
  
  include WXf::WXfassists::Auxiliary::Joomla
  
  def initialize
    super(

            'Name'        => 'Joomla Version Scanner',
            'Description' => %q{
         
                            
               
            },
            'References'  =>
             [
              
             ],
            'Author'      => [ 'CKTRICKY',],
            'License'     => WXF_LICENSE
  
    )
          

  end
  
  def run
  
  
  end

end
