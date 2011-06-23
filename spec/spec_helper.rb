rrunit_path = File.expand_path('./lib', File.dirname(__FILE__))
$:.unshift(rrunit_path) if File.directory?(rrunit_path) && !$:.include?(rrunit_path)

require 'rrunit'

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec
  
  ## perhaps this should be removed as well
  ## and done in Rakefile?
  config.color_enabled = true
  ## dont do this, do it in Rakefile instead
  #config.formatter = 'd'
end