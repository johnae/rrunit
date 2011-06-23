rrunit_path = File.expand_path('./lib', File.dirname(__FILE__))
$:.unshift(rrunit_path) if File.directory?(rrunit_path) && !$:.include?(rrunit_path)

require 'rrunit'

RSpec.configure do |config|
  config.mock_with :rspec
  config.color_enabled = true
  config.formatter = 'd'
end