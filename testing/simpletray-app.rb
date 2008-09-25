# an example system tray app using simpletray
require 'simpletray'

SimpleTray.app 'My App' do {

  'First' => lambda { puts "CLICKED FIRST" },
  'Second' => lambda { puts "CLICKED SECOND" }

} end
