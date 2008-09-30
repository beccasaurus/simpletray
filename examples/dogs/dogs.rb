#! /usr/bin/env ruby
#%w( rubygems simpletray ).each {|lib| require lib }
require File.dirname(__FILE__) + '/../../lib/simpletray'

dog_image_numbers = Dir[File.join(File.dirname(__FILE__),'?.png')].sort.map { |x| x.sub(/.*(\d+).png$/,'\1') }

SimpleTray.app 'Dogs' do

  dog_image_numbers.each do |i|
    item("Dog #{i}", "#{i}.png" ){ msgbox "you clicked on dog ##{i}" }
  end

  _dogs_ do
    dog_image_numbers.each do |i|
      item("Dog #{i}", "#{i}.png" ){ msgbox "you clicked on dog ##{i}" }
    end
  end
  ____
  exit

end
