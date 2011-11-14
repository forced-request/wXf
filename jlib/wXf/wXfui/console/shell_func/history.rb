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
    
    self.history_file = "#{WXf::WXF_HOME_DIR}/history"
    
    if ! ::File.exists?("#{self.history_file}")
      File.new("#{self.history_file}", "w+")
    end
    
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
