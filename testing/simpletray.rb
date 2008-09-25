%w( rubygems wx ).each {|lib| require lib }

=begin
class SimpleTray
  def self.app &block
  end
end
=end

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
      @menu.append_item Wx::MenuItem.new(@menu, 1234 + i, k_v.inspect)
    end
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
