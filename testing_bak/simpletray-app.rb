# an example system tray app using simpletray
require 'simpletray'

SimpleTray.run lambda {{
  'This' => nil,
  'That' => nil
}}

=begin
  [
    {
      :title => '',
      :icon  => '',
      :items => #callable
    }
  ]
=end
=begin
SimpleTray.app do
  menu do
     # ...
  end
end
=end
=begin
  %w( lighthouse jira ).each {|l| require "simpletray-#{l}" }
  SimpleTray.run {
    :title => '',
    :icon  => '',
    :items => [
      ::Lighthouse.new :username => '', :project => '', :title => '', :icon => ''
    ]
  }
=end
