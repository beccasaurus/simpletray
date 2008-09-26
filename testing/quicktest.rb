#! /usr/bin/env ruby1.8.6
%w( rubygems wx activesupport ).each {|lib| require lib }

### WX Stuff (will likely move to a helper, but i wanna clean it up here first)

def msgbox msg
  Wx::MessageDialog.new(@frame, msg, 'Ashacache', Wx::OK, Wx::DEFAULT_POSITION ).show_modal
end

### SimpleTray

class SimpleTray
  def self.app title, &block
    # App.new.instance_eval &block
    run { App.new title, &block }
  end
  def self.run &block
    Wx::App.run &block
  end

  class MenuItem < Wx::MenuItem
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

    # everything below here copied (for testing - i will DRY it up)
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
  
  class App < Wx::TaskBarIcon
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

    # all below here is shared ... will DRY up ...
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
end

SimpleTray.app 'My Cool App' do
  
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
  end

  exit

end
