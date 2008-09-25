%w( rubygems wx ).each {|lib| require lib }

=begin
class SimpleTray
  def self.app &block
  end
end
=end

class SimpleTrayIcon < Wx::TaskBarIcon
  def initialize
    super
    set_icon Wx::Icon.new( 'icon.png', Wx::BITMAP_TYPE_PNG ), 'Icon Title Here'
		evt_menu(Wx::ID_EXIT) { exit }
  end
  def create_popup_menu
		@menu = Wx::Menu.new
    #@menu.append_item MembersMenuItem.new(@menu, 7000, 'Members')
		@menu.append_separator
		@menu.append Wx::ID_EXIT, 'Quit'
    @menu
  end
end

class SimpleTray
  def self.run app
    # items = app.call
    Wx::App.run do
      SimpleTrayIcon.new
    end
  end
end
