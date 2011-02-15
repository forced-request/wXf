module WXf
module WXfui
module Console
module Prints



# Banner module.

module PrintDisplay


        Logos = [
        
# Seth, if we would like to add more banners we just need to encapsulate w/ array by [] and seperate w/ comma ,
# also notice that each logo is wrapped in apostrophes so the effect is Logos=['logo1', 'logo2'] 

#06-03-2010 As a general rule of thumb place 2 carriage returns after the logo but before the comma                                    
        
'
                
/\ \  _ \ \   /\_\_\_\   /\  ___\ 
\ \ \/ ".\ \  \/_/\_\/_  \ \  __\ 
\ \__/".~\_\   /\_\/\_\  \ \_\   
 \/_/   \/_/   \/_/\/_/   \/_/   

          
',
'


          __  __ __ 
 __      __ \/ // _|
 \ \ /\ / /\  /| |_ 
  \ V  V / /  \|  _|
   \_/\_/ /_/\_\_|

  
',
'
          XX    XX  fff 
ww      ww  XX  XX  ff   
ww      ww   XXXX   ffff 
ww ww ww   XX  XX  ff   
 ww  ww   XX    XX ff   


',

#
# If you'd like to put your name after welcome
#...visit http://patorjk.com/software/taag/ and use font B1FF 
#
'
 #     #                                                                         
 #  #  # ###### #       ####   ####  #    # ######    
 #  #  # #      #      #    # #    # ##  ## #          
 #  #  # #####  #      #      #    # # ## # #####      
 #  #  # #      #      #      #    # #    # #      
 #  #  # #      #      #    # #    # #    # #         
  ## ##  ###### ######  ####   ####  #    # ######     
'                                          
]
  def self.to_s
      Logos[rand(Logos.length)]   
    end
  
  end
  
end end end end                                     