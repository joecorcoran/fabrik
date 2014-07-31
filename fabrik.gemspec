# -*- encoding: utf-8 -*-
require File.expand_path('../lib/fabrik/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'fabrik'
  s.version     = Fabrik::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Joe Corcoran']
  s.email       = ['joecorcoran@gmail.com']
  s.homepage    = 'http://github.com/joecorcoran/fabrik'
  s.summary     = 'Traits for Ruby 2'
  s.license     = 'MIT'
  s.description = <<-txt
Traits for Ruby 2, as described in the paper "Traits: A Mechanism for
Fine-grained Reuse" by Ducasse, Nierstrasz, Schärli, Wuyts and Black.
txt

  s.add_development_dependency 'rspec', '~> 3.0'

  s.files        = Dir['lib/**/*.rb'] + ['README.md', 'LICENSE.txt']
  s.require_path = 'lib'
end
