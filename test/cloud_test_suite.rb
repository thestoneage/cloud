#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), 'cloud_test_helper')

Dir[File.join(File.dirname(__FILE__), '**/test_*.rb')].each { |test| require test }
