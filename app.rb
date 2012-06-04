root = File.dirname(__FILE__)
$LOAD_PATH.unshift File.join(root, 'lib')
ENV['BUNDLE_GEMFILE'] ||= File.join(root, 'Gemfile')
require 'bundler'
Bundler.require

require "sudden_killer"
require 'optparse'

tokens = {}
OptionParser.new do |opt|
  opt.on('-t oauth token')        { |str| tokens[:oauth_token]        = str }
  opt.on('-T oauth token secret') { |str| tokens[:oauth_token_secret] = str }
  opt.on('-c consumer key')       { |str| tokens[:consumer_key]       = str }
  opt.on('-C consumer secret')    { |str| tokens[:consumer_secret]    = str }
end.parse!(ARGV)

SK::TwitterInterface::Configuration.configure do |config|
  config.oauth_token        = tokens[:oauth_token]
  config.oauth_token_secret = tokens[:oauth_token_secret]
  config.consumer_key       = tokens[:consumer_key]
  config.consumer_secret    = tokens[:consumer_secret]
end

killer = SK::Killer.new(File.join(SK.root, 'okura-dic'))
SK::TwitterInterface.new(killer).run
