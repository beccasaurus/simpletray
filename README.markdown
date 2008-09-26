# simpletray

simpletray is a gem for making it really easy to make wxruby-based system tray applications

![SimpleTray Screenshot](http://github.com/remi/simpletray/tree/master/simpletray.png?raw=true)

## installation

simpletray uses wxWidgets, so you need to install wx: http://www.wxwidgets.org/

a binary should be available for Windows users.  Mac/Linux should be able to use your packaging systems.

now, install the required rubygems ...

    $ sudo gem install wxruby activesupport

and ... simpletray!

    $ sudo gem install remi-simpletray -s http://gems.github.com

## usage

    #! /usr/bin/env ruby
    require 'rubygems'
    require 'simpletray'

    # icon my_cool_app.png will be used for the tray icon
    SimpleTray.app 'My Cool App' do

      # this makes a single item 'About' (about.png will be used if found)
      # which pops up a message box when clicked
      about { msgbox "Hello!  This is my app!" }

      # this makes a submenu 'Dogs' with rover/spot/rex subitems.
      # dogs.png, rover.png, spot.png, rex.png will all be looked for
      _dogs_  {
        rover { puts "..." }
        spot  { puts "..." }
        rex   { msgbox "w00f, my name is rex!" } 

        _more_dogs_ do
          another_dog     { puts "..." }
          yet_another_dog { puts "..." }
        end
      }

      # adds an item (the same as saying my_custom_item) with a custom icon
      item 'My Custom Item', 'custom-icon.png' do
        # ...
      end

      # adds an menu (the same as saying _my_custom_menu_) with a custom icon
      menu 'My Custom Menu', 'custom-menu-icon.png' do
        item1 { }
        item2 { }
      end

      # this adds a seperator and then a special 'exit' item to quit the application
      ____
      exit

    end

Also, see examples/first.rb (the first file I used for testing), which shows how to add 
your own helper methods

Note, currently I'm only supporting PNGs.  I'll fix this to support ICO/PNG/BMP/JPG/etc.
My TODO list is long  :P
