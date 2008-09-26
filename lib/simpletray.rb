$:.unshift File.dirname(__FILE__)
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
  # Whatever you do, do NOT override the methods used 
  # in this module, *especially* not #method_missing.
  #
  # If you want to override the behavior of one of these 
  # methods, ***PLEASE*** use #alias_method_chain.
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

  # Used *internally* by SimpleTray
  #
  # Represents a menu item that has a web menu.
  #
  # This dynamically creates the menu when your mouse 
  # highlights / hovers over the menu.  See #on_highlight
  #
  class MenuItem < Wx::MenuItem
    include Builder
  
    def initialize menu, name, icon = nil, &block
      super menu, -1, name
      @menu = menu
      @item_block = block
      self.get_menu.evt_menu_highlight(self){ |evt| on_highlight(evt) }
      @menu = Wx::Menu.new
      self.set_sub_menu @menu
    end
  
    def on_highlight(evt)
      instance_eval &@item_block if @menu.get_menu_item_count == 0
    end
  end
  
  # Used *internally* by SimpleTray
  #
  # Represents the top-level system tray icon
  #
  # Menu items are dynamically created each time you click on 
  # the system tray icon.  See #create_popup_menu
  #
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
