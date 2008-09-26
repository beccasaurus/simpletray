#! /usr/bin/env ruby
require 'rubygems'
require 'simpletray'

module SimpleTray::Builder
  def popup name, message
    item( name ){ msgbox message }
  end
end

SimpleTray.app 'My Cool App' do

  popup 'testing 1,2,3', 'this is my message'
  
  about { puts "this is my tray app!" }

  msgbox_hi { msgbox "hello!" }
  _____

  item 'My Name' do 
  end

  item 'blah', lambda { puts 'hello from blah' }

  _menu_ 'xxx' do 
    menu_item_1 { msgbox "you clicked menu item 1!" }
    ___
    menu_item_2 { puts "clicked number 2 !!!!!" }
  end

  options { puts "on click" }

  _options_ do
    profile { puts "your profile" }
    neato   { puts "blah!"        }
    _nested_ do
      _more_ do
        clicky { msgbox "yay!" }
      end
    end
  end

  exit

end
