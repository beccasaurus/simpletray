#! /usr/bin/env ruby1.8.6
%w( rubygems wx activesupport ).each {|lib| require lib }

class SimpleTray

  # Use this to run your SimpleTray application
  #
  #  SimpleTray.app 'My Cool App' do
  #    about { msgbox "My App!" }
  #    exit
  #  end
  #
  def self.app title, &block
    Wx::App.run { Icon.new title, &block }
  end

  # This is where the magic happens.
  #
  # Any methods you add to this module will be available in the DSL
  #
  #  module SimpleTray::Builder
  #    def popup name, message
  #      item( name ){ msgbox message }
  #    end
  #  end
  #
  #  SimpleTray.app 'My Cool App' do
  #   popup 'Click Me', 'Hello!  This is my message!'
  #  end
  #
  module Builder

    def item name, icon = nil, &block
      block = icon if block.nil? and icon.respond_to?:call
      item = Wx::MenuItem.new @menu, -1, name
      @menu.append_item item
      @menu.evt_menu(item){ block.call }
      item
    end

    def menu name, icon = nil, &block
      block = icon if block.nil? and icon.respond_to?:call
      item = SimpleTray::MenuItem.new @menu, name, icon, &block
      @menu.append_item item
    end

    def seperator
      @menu.append_separator
    end

    def exit name = 'Quit'
      @menu.append Wx::ID_EXIT, name
      @menu.evt_menu(Wx::ID_EXIT){ Kernel::exit }
    end

    alias quit exit

    def msgbox msg
      Wx::MessageDialog.new(@frame, msg, 'Ashacache', Wx::OK, Wx::DEFAULT_POSITION ).show_modal
    end

    def method_missing method, *args, &block
      method = method.to_s
      if method[/^_*$/]
        seperator
      elsif method[/^_.*_$/]
        menu method.titleize.strip, *args, &block
      else
        item method.titleize, *args, &block
      end
    end
  end

  class MenuItem < Wx::MenuItem
    include Builder
    def initialize menu, name, icon = nil, &block
      super(menu, -1, name)
      @menu = menu
      @item_block = block
      self.get_menu.evt_menu_highlight(self){ |evt| on_highlight(evt) }
      @menu = Wx::Menu.new
      self.set_sub_menu @menu
    end
    def on_highlight(evt)
      if @menu.get_menu_item_count == 0
        instance_eval &@item_block
      end
    end
  end
  
  class Icon < Wx::TaskBarIcon
    include Builder
    def initialize title, icon = nil, &block
      super()
      @title = title
      @icon  = icon || @title.titleize.gsub(' ','').underscore + '.png' # 'My Cool App' => 'my_cool_app.png'
      refresh_icon
      @item_block = block
    end
    def icon= path
      @icon = path
    end
    def refresh_icon
      set_icon Wx::Icon.new( @icon, Wx::BITMAP_TYPE_PNG ), @title if File.file?@icon
    end
    def create_popup_menu
      @menu = Wx::Menu.new
      instance_eval &@item_block
      @menu
    end
  end
end

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
