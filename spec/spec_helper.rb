# coding: utf-8

root = File.join(File.dirname(__FILE__), '..')
$LOAD_PATH.unshift File.join(root, 'lib')

ENV['BUNDLE_GEMFILE'] ||= File.join(root, 'Gemfile')

require 'bundler'
Bundler.require(:default, :test)
require 'sudden_killer'

Dir[File.join(File.dirname(__FILE__), "..", "lib", "*.rb")].each{ |f| require f }
