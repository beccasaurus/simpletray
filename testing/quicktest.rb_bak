#! /usr/bin/env ruby

class SimpleTray
  def self.menu title, &block
    puts "title: #{title}"
    App.new.instance_eval &block
  end
  
  # PLUGINS SHOULD EXTEND THIS
  class App
    def initialize
    end
    def item *args
      puts "called ITEM with #{args.inspect}"
    end
    def method_missing method, *args, &block
      puts "App.method_missing for #{method.inspect} with #{args.inspect} and block: #{block.inspect}"
    end
  end
end

SimpleTray.menu 'Title' do
  
  about { alert "this is my tray app!" }
  _____

  item 'My Name' do 
  end

  item 'blah', lambda {}

  menu do 
    # ...
  end

=begin
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


  seperator

  exit

  ________

  # ^ if __ >= 2 chars, insert seperator
=end

end
