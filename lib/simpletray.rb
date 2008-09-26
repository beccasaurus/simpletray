$:.unshift File.dirname(__FILE__)
%w( rubygems wx activesupport ).each {|lib| require lib }

class SimpleTray
  cattr_accessor :icon_directory

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
      if block.nil? and icon.respond_to?:call
        block = icon 
        icon  = nil
      end
      item = Wx::MenuItem.new @menu, -1, name

      icon ||= name.titleize.gsub(' ','').underscore + '.png' # 'My Cool App' => 'my_cool_app.png'
      icon = File.join SimpleTray.icon_directory, icon unless File.file?icon
      if File.file?icon
        icon = Wx::Bitmap.new icon, Wx::BITMAP_TYPE_PNG
        item.set_bitmap icon
      end
      
      @menu.append_item item
      @menu.evt_menu(item){ block.call }
      item
    end

    def menu name, icon = nil, &block
      if block.nil? and icon.respond_to?:call
        block = icon 
        icon  = nil
      end
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
      @name = name
      @icon = icon || @name.titleize.gsub(' ','').underscore + '.png' # 'My Cool App' => 'my_cool_app.png'
      @icon = File.join SimpleTray.icon_directory, @icon unless File.file?@icon
      init_icon
      @item_block = block
      self.get_menu.evt_menu_highlight(self){ |evt| on_highlight(evt) }
      @menu = Wx::Menu.new
      self.set_sub_menu @menu
    end

    def init_icon
      if File.file?@icon
        icon = Wx::Bitmap.new @icon, Wx::BITMAP_TYPE_PNG
        set_bitmap icon
      end
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
      @icon  = File.join SimpleTray.icon_directory, @icon unless File.file?@icon
      init_icon
      @item_block = block
    end
  
    def icon= path
      @icon = path
    end
  
    def init_icon
      unless File.file?@icon
        raise "SimpleTray icon not found!  #{ @icon }.  Try: SimpleTray.app 'title', 'path to icon'.  " + 
              "Or set SimpleTray.icon_directory to the directory where your icons reside."
      else
        refresh_icon
      end
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

# default the icon directory to what we *think* is the path of the script being run
SimpleTray.icon_directory = File.expand_path(File.dirname($0))
