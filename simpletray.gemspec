Gem::Specification.new do |s|

  s.name = "simpletray"
  s.version = "0.0.8"
  s.date = "2008-09-26"
  s.summary = "Ruby gem that provides a DSL for creating system tray icon applications *really* easily."
  s.email = "remi@remitaylor.com"
  s.homepage = "http://github.com/remi/simpletray"
  s.description = "Ruby gem that provides a DSL for creating system tray icon applications *really* easily."
  s.has_rdoc = true
  s.rdoc_options = ["--quiet", "--title", "SimpleTray - creating system tray icons", "--opname", "index.html", "--line-numbers", "--main", "SimpleTray", "--inline-source"]
  s.authors = ["remi Taylor"]

  # generate using: $ ruby -e "puts Dir['**/**'].select{|x| File.file?x}.inspect"
  s.files = ["examples/first.rb", "examples/my_cool_app.png", "examples/readme.rb", "examples/dogs/dogs.png", "examples/dogs/3.png", "examples/dogs/7.png", "examples/dogs/6.png", "examples/dogs/4.png", "examples/dogs/dogs.rb", "examples/dogs/2.png", "examples/dogs/5.png", "examples/dogs/1.png", "lib/simpletray.rb", "simpletray.png", "README.markdown", "tmp/test.html", "simpletray.gemspec", "doc/README.rdoc", "Rakefile"]

end
