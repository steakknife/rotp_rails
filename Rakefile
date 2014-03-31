begin
  require 'bundler/setup'
rescue LoadError
  $stderr.puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
  raise
end
Bundler::GemHelper.install_tasks

require 'rdoc/task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'RotpRails'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task default: :spec
