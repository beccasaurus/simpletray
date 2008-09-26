require 'rake/rdoctask'

Rake::RDocTask.new do |rdoc|
      files = ['doc/README.rdoc','lib/**/*.rb', 'doc/**/*.rdoc', 'test/*.rb']
      rdoc.rdoc_files.add(files)
      rdoc.main = 'doc/README.rdoc'
      rdoc.title = 'SimpleTray'
      rdoc.rdoc_dir = 'doc'
      rdoc.options << '--line-numbers' << '--inline-source'
end
