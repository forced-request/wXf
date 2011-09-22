module WXf
module WXfui
module Console
module Shell_Func

  
class History
  
  attr_accessor :history_file
  
  def initialize
    history_file_init
  end
  
  def history_file_init
    home_dir = ENV['HOME']
    wXf_home_dir = "#{home_dir}/.wXf"
    
    if ::File.exists?(wXf_home_dir)
      #Stub, maybe add something?
    else
      ::Dir.mkdir(wXf_home_dir)
    end  
    
    self.history_file = "#{wXf_home_dir}/history"
    hist_file    
  end
  
  def hist_file
    hfile =  File.open("#{self.history_file}", "r")
    hfile.each do |line|
      line.chomp!
      ::Readline::HISTORY.push(line)
    end
    hfile.close
  end
  

end

end end end end
