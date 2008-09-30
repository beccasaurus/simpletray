#! /usr/bin/env ruby
%w( rubygems wx ).each {|lib| require lib }

# To discover my highlight event bug, I need to create a very
# simple Icon with an item and a submenu and get the different
# events working properly - test this OK on Windows / OS X - 
# then fix SimpleTray
#
# I intend on implementing EVERY POSSIBLE EVENT that I might want 
# to take advantage of here, and then implementing them in SimpleTray

class AnItem < Wx::MenuItem
  def initialize *args
    super *args

    @menu = args.first # parent menu, which this item is inside of ... or whatever

    # @menu.evt_menu_highlight(self){  }

    @submenu = Wx::Menu.new #'AnItem @menu'
    @submenu.append 'First Item'
    @submenu.append 'Second Item'
    @submenu.evt_menu_close { puts "@submenu closed!" }
    @submenu.evt_menu_open { puts "@submenu opened!" }
    @submenu.evt_menu_highlight_all{ puts "highlight ALL" }

    self.set_sub_menu @submenu
  end
end

class MyTaskBarIcon < Wx::TaskBarIcon

  def initialize
    super()
    @icon = 'my_cool_app.png'
    set_icon Wx::Icon.new( @icon, Wx::BITMAP_TYPE_PNG ), 'w00t'
  end

  def create_popup_menu
    menu = Wx::Menu.new 'Hello There'
    menu.append 'I do Nothing'
    clicky = menu.append 'Clicky'
    menu.evt_menu(clicky) { puts "Clicky!!!" }
    #menu.append_item MembersMenuItem.new(@menu, 7000, 'Members')
		menu.append_separator
    
    an_item = AnItem.new( menu, 12345, 'AnItem.new' )
    menu.append_item an_item
    menu.evt_menu(an_item){ puts "something having to do with an_item!" }
    menu.evt_menu_highlight(an_item){ puts "highlighted an_item!" }
    menu.evt_menu_highlight_all{ puts "highlight ALL" }
    menu.evt_menu_close { puts "top-level menu closed!" }
    menu.evt_menu_open { puts "top-level menu opened!" }

		menu.append_separator
		quit_item = menu.append Wx::ID_ABOUT, 'About'
		quit_item = menu.append Wx::ID_EXIT, 'Quit'
    menu.evt_menu(quit_item) { exit }
    menu
  end

end

puts "Starting ..."
Wx::App.run { MyTaskBarIcon.new }
