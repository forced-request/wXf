#!/usr/bin/env jruby

import java.awt.Color
import javax.swing.JPanel
import javax.swing.JTextPane

import javax.swing.text.StyleConstants
import javax.swing.text.StyleContext
import javax.swing.text.StyledDocument

module WxfGui
  
  class GeneralPanel < JPanel
    include WxfGui::DatabaseManagerModule
    
    def initialize
      super
      init
    end
    
    def init
      
      @textPane = JTextPane.new
      @textPane.editable = false
      @doc = @textPane.getStyledDocument()
      add_blue_style
      add_red_style
      add_green_style
      add_dark_blue_style
      add_dark_red_style
      add_dark_green_style
      add_generic_style
      
      @clear_button = JButton.new "clear"
      @clear_button.add_action_listener do |e|
        clear_document
      end
      
      @restore_button = JButton.new "restore"
      @restore_button.add_action_listener do |e|
        restore
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
      sv1 = layout.createSequentialGroup
      sv2 = layout.createSequentialGroup
      sv3 = layout.createSequentialGroup
      p1 = layout.createParallelGroup
      p2 = layout.createParallelGroup
      
      layout.setHorizontalGroup sh1
      layout.setVerticalGroup sv3      
      
      sv1.addComponent(@textPane)
      sv2.addComponent(@clear_button)
      sv2.addComponent(@restore_button)
      p1.addGroup sv1
      p1.addGroup sv2  
      sv3.addGroup p1
      
      p2.addComponent(@clear_button)
      p2.addComponent(@restore_button)
      sh1.addComponent(@textPane)
      sh1.addGroup p2
      
       layout.linkSize SwingConstants::HORIZONTAL, 
          @restore_button, @clear_button
      
    end
    
    def clear_document
       start = @doc.getStartPosition().getOffset.to_i
       stop =  @doc.getEndPosition().getOffset.to_i - 1
       @doc.remove(start, stop) 
    end
    
    def add_green_style
      style = @textPane.addStyle("Green", nil)
      StyleConstants.setBold(style, true);
      StyleConstants.setForeground(style, Color.green)
    end
    
    def add_red_style
      style = @textPane.addStyle("Red", nil)
      StyleConstants.setBold(style, true);
      StyleConstants.setForeground(style, Color.red())
    end
    
    def add_blue_style
      style = @textPane.addStyle("Blue", nil)
      StyleConstants.setBold(style, true);
      StyleConstants.setForeground(style, Color.blue())
    end
    
    def add_dark_green_style
      style = @textPane.addStyle("DarkGreen", nil)
      StyleConstants.setBold(style, true);
      StyleConstants.setForeground(style, Color.green.darker())
    end
    
    def add_dark_red_style
      style = @textPane.addStyle("DarkRed", nil)
      StyleConstants.setBold(style, true);
      StyleConstants.setForeground(style, Color.red.darker())
    end
    
    def add_dark_blue_style
      style = @textPane.addStyle("DarkBlue", nil)
      StyleConstants.setBold(style, true);
      StyleConstants.setForeground(style, Color.blue.darker())
    end
    
    def add_generic_style
      style = @textPane.addStyle("Generic", nil)
      StyleConstants.setBold(style, true);
      StyleConstants.setForeground(style, Color.black)
    end
    
    def time
      str = "[#{Time.now.to_s[0..-12]}]\n\n"
      return str     
    end
    
    def add_time(time_now)
      style = @textPane.getStyle("DarkGreen")
      @doc.insertString(@doc.getLength(), time_now, style)      
    end
    
    def acceptable_colors
      {
        "Green"     => @textPane.getStyle("Green"),
        "Red"       => @textPane.getStyle("Red"),
        "Blue"      => @textPane.getStyle("Blue"),
        "DarkGreen" => @textPane.getStyle("DarkGreen"),
        "DarkBlue"  =>  @textPane.getStyle("DarkBlue"),
        "DarkRed"   =>  @textPane.getStyle("DarkRed"),
        "Generic"   =>  @textPane.getStyle("Generic")
      }
    end
    
    
    def add_text(text, color, t=nil, restore=false)
      return unless acceptable_colors.has_key?(color)      
      t = t.nil? ? time : "[#{t}]\n\n"  
      
      if not text.empty?        
        if not restore
          db_add_general_text(text, color, t)
        end 
        add_time(t)
        style = acceptable_colors[color]      
        @doc.insertString(@doc.getLength(), "#{text}\n\n", style)
      end   
    end
    
    def restore
      clear_document
      rows = retrieve_general_table
      rows.each do |row|
        text  = row[0].to_s
        color = row[1].to_s
        time  = row[2].to_s
        add_text(text, color, time, true)
      end
    end
    
  end

end 