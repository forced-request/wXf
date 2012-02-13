module WxfGui
  
  class DataEntryPanel < JPanel
     
     def initialize(sca)
        @sca = sca
        super(FlowLayout.new(FlowLayout::LEFT))
        init
     end
     
     def init
        
        # Buttons
        chooseDir = JButton.new("choose")
        searchButton = JButton.new("search")
     
     
        # Labels      
        l1 = JLabel.new("Directory to search")
        l2 = JLabel.new("String to search for")
        l3 = JLabel.new("Extension - txt,csv")
        
        # Text Fields
        @tf1 = JTextField.new(30)
        @tf2 = JTextField.new(30)
        @tf3 = JTextField.new(10)
        
        # Jpanel(s)
        jp1 = JPanel.new(FlowLayout.new(FlowLayout::LEFT))
        jp1.add(l1)
        jp1.add(@tf1)
        jp2 = JPanel.new(FlowLayout.new(FlowLayout::LEFT))
        jp2.add(l2)
        jp2.add(@tf2)
        jp3 = JPanel.new(FlowLayout.new(FlowLayout::LEFT))
        jp3.add(l3)
        jp3.add(@tf3)
     
     
        # Add listener actions to button
        #
        # Choose Directory Button
        chooseDir.addActionListener do |e|
          dir = JFileChooser.new
          dir.setCurrentDirectory(java.io.File.new(Dir.pwd))
          dir.setFileSelectionMode(JFileChooser::DIRECTORIES_ONLY)
          dir.setFileHidingEnabled(false)
          ret = dir.showDialog @panel, "Choose Directory"
          if  ret  == JFileChooser::APPROVE_OPTION
              destDir = dir.getCurrentDirectory()
              searchDir = destDir.to_s
              @tf1.text = searchDir.length > 0 ? searchDir : ''
          end 
        end 
        
        # Search button
        searchButton.addActionListener do |e|
           if @tf1.text.length <= 0
             error("Please enter a directory")
           elsif not File.directory?(@tf1.text.to_s)
             error("That directory does not exist, try again")
           elsif @tf2.text.length <= 0
             error("Please enter something to search for")
           elsif @tf3.text.length <= 0
             opt = yes_no_error("You've not entered an extension. Check all filetypes?\nThis will take some time...")
             case opt
             when 0
               @tf3.text = ''
               search
             else
             end
           else
              search
           end
        end
        
        #
        # GROUP LAYOUT OPTIONS
        #
        
        layout = GroupLayout.new self
        # Add Group Layout to the frame
        self.setLayout layout
        # Create sensible gaps in components (like buttons)
        layout.setAutoCreateGaps true
        layout.setAutoCreateContainerGaps true     
      
        sh1 = layout.createSequentialGroup
        sh2 = layout.createSequentialGroup
        sh3 = layout.createSequentialGroup
        sv1 = layout.createSequentialGroup
        sv2 = layout.createSequentialGroup
        sv3 = layout.createSequentialGroup
        p1 = layout.createParallelGroup
        p2 = layout.createParallelGroup
        p3 = layout.createParallelGroup
        p4 = layout.createParallelGroup
        p5 = layout.createParallelGroup
        
        layout.setHorizontalGroup sh3
        layout.setVerticalGroup sv3
        
        
        # Horizontal
        p1.addComponent(jp1)
        p1.addComponent(jp2)
        p1.addComponent(jp3)
        p2.addComponent(chooseDir)
        p2.addComponent(searchButton)
        sh3.addGroup(p1)
        sh3.addGroup(p2)
        
        
        # Vertical
        sv1.addComponent(jp1)
        sv1.addComponent(jp2)
        sv1.addComponent(jp3)
        sv2.addComponent(chooseDir)
        sv2.addComponent(searchButton)
        p5.addGroup(sv1)
        p5.addGroup(sv2)
        sv3.addGroup(p5)
        
        layout.linkSize SwingConstants::HORIZONTAL, 
            chooseDir, searchButton
  
     end
     
    def error(text)
       JOptionPane.showMessageDialog self, "#{text}",
          "Error", JOptionPane::ERROR_MESSAGE     
    end
    
    def yes_no_error(text)
      jo = JOptionPane.showConfirmDialog(nil, 
           "#{text}", 
           "Confirmation", 
           javax.swing.JOptionPane::YES_NO_OPTION, 
           javax.swing.JOptionPane::QUESTION_MESSAGE)
      return jo
    end 
      
      def search
         if @tf1.text.length > 0 and @tf2.text.length > 0
            if File.directory?("#{@tf1.text}")
               finder
            end
         end
      end
      
      def finder
         # Define instance arrays
         @file_array = []
         result_arry = []
         ext_arry    = []
         
         # Sanity Check
         return unless @tf1.text.length > 0
         return unless @tf3.text.kind_of?(String)
         ext = @tf3.text.gsub(/\.|\s/, '')
         ext_arry = ext.split(',')
         extension = ext == '' ? "*" : ext
         
         #First loop, to collect
         if ext_arry.empty?
            Find.find(@tf1.text) do |file|
              if File.file?(file)    
                @file_array<<(file)
              end
            end 
         else
            Find.find(@tf1.text) do |file|
              if File.file?(file) and ext_arry.include?(File.extname(file).to_s.gsub(/\./, ''))     
                @file_array<<(file)
              end
            end
         end
         
        
         # Second loop, to read
         begin
         @file_array.each do |file|
            f = File.open(file, "r")
            f.each_with_index do |line, idx|
              idx +=1
               if line.include?("#{@tf2.text}") || line.include?("#{@tf2.text.downcase}") || line.include?("#{@tf2.text.capitalize}")
                  result_arry <<(["#{file}", "#{idx}", "#{@tf2.text}", "#{extension}"])
               end
            end
            f.close()
         end 
         @sca.results_table.insert_results(result_arry)
         #Put a finished message here or maybe add a progress
         rescue Errno::EACCES
           
         end 
      end
  end
  
end