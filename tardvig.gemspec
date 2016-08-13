require File.expand_path(File.dirname(__FILE__) + '/lib/tardvig/version.rb')

Gem::Specification.new do |s|
  s.name = 'tardvig'
  s.version = Tardvig::VERSION
  s.summary = 'Lightweight structure for Ruby-based games'
  s.description = <<DOC
Tardvig is a bundle of classes and modules which can be integrated and extended to make a game engine.
DOC
  s.homepage = 'https://github.com/sprkweb/tardvig'
  s.author = 'Vadim Saprykin'
  s.email = 'sprkweb@ya.ru'
  s.files = ['lib/tardvig.rb']
  s.license = 'MIT'

  s.required_ruby_version = '>= 2.0.0'
  s.add_development_dependency 'rake', '~> 11.2'
  s.add_development_dependency 'rspec', '~> 3.4'
  s.add_development_dependency 'yard', '~> 0.8'
  s.add_development_dependency 'redcarpet', '~> 3.3'
end
