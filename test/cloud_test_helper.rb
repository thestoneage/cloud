require 'test/unit'
begin require 'rubygems'; rescue LoadError
else begin gem 'mocha', '~> 0.9.0'; rescue Gem::LoadError; end end
require 'mocha'

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')

