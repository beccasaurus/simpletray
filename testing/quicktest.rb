#! /usr/bin/env ruby1.8.6
%w( rubygems wx activesupport ).each {|lib| require lib }

### WX Stuff (will likely move to a helper, but i wanna clean it up here first)

def msgbox msg
  Wx::MessageDialog.new(@frame, msg, 'Ashacache', Wx::OK, Wx::DEFAULT_POSITION ).show_modal
end

class DynamicMenuItem < Wx::MenuItem
  def initialize *args
    super *args
    self.get_menu.evt_menu_highlight(self){ |evt| on_highlight(evt) }
    @menu = Wx::Menu.new
    self.set_sub_menu @menu
  end
  def on_highlight(evt)  end
end

class MembersMenuItem < DynamicMenuItem
  def on_highlight(evt)
    if @menu.get_menu_item_count == 0
      %w( why hello there ).each_with_index do |x,i|
        menuitem = Wx::MenuItem.new @menu, -1, x
        @menu.append_item menuitem
        @menu.evt_menu(menuitem) { msgbox("clicked on item: #{x}") }
        ## @menu.append_item MemberMenuItem.new(@menu, 8000 + i, x)
      end
    end
  end
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
    def item name, icon = nil, &block
      block = icon if block.nil? and icon.respond_to?:call
      item = Wx::MenuItem.new @menu, -1, name
      @menu.append_item item
      @menu.evt_menu(item){ block.call }
      item
    end
    def menu name, icon = nil, &block
      block = icon if block.nil? and icon.respond_to?:call
      item = MembersMenuItem.new @menu, 7000, name
      @menu.append_item item
    end
    def seperator
      puts "seperator"
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

  menu 'xxx' do 
    # ...
  end

  options { puts "on click" }

  _options_ do
    profile { puts "your profile" }
    neato   { puts "blah!"        }
  end

  exit

end
