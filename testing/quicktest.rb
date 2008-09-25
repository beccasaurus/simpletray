#! /usr/bin/env ruby

SimpleTray.menu 'Title' do
  
  my_tickets.click {}
  my_tickets.items {}

  my_tickets_click {}
  my_tickets { '... '}

  my_tickets_options do
    ...
    ...
  end

  options { puts "on click" }

  _options_ do
    profile { puts "your profile" }
    neato   { puts "blah!"        }
  end

  about { alert "this is my tray app!" }

  seperator

  exit

  ________

  # ^ if __ >= 2 chars, insert seperator

end
