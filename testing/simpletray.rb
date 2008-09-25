#
# IDs ... the standard ones: http://wxruby.rubyforge.org/wiki/wiki.pl?Built-In_Constants
#         randomly generate ones > 10,000 for our apps.
#
#         ... or does -1 work and i don't care?
#
#         SimpleTray.unused_menu_id         # get an id (doesn't change anything)
#         SimpleTray.unused_menu_id(object) # this object has taken this menu item! (maybe give this a key/name, too?)
#

%w( rubygems wx ).each {|lib| require lib }

=begin
class SimpleTray
  def self.app &block
  end
end
=end

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

# i need a helper method to return a class like this
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

class SimpleTrayIcon < Wx::TaskBarIcon
  attr_accessor :title, :items
  def initialize title,  items
    super()
    @items, @title = items, title
    set_icon Wx::Icon.new( 'icon.png', Wx::BITMAP_TYPE_PNG ), @title
		evt_menu(Wx::ID_EXIT) { exit }
  end
  def create_popup_menu
		@menu = Wx::Menu.new
    #@menu.append_item MembersMenuItem.new(@menu, 7000, 'Members')
    @items.each_with_index do |k_v,i|
      item = Wx::MenuItem.new(@menu, -1, k_v.first)
      @menu.append_item item
      @menu.evt_menu(item) { k_v.last.call } if k_v.last.respond_to?:call
    end

    dynamic_item = MembersMenuItem.new(@menu, 7000, 'Members')
    @menu.append_item dynamic_item
    @menu.evt_menu(dynamic_item) { puts("clicked the DYNAMIC item!!!") } # not possible  :(

		@menu.append_separator
		@menu.append Wx::ID_EXIT, 'Quit'
    @menu
  end
end

class SimpleTray
  def self.app title, &block
    Wx::App.run { SimpleTrayIcon.new title, yield }
  end
end
