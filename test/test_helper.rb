$:.unshift File.expand_path('../../lib', __FILE__)
require 'minitest/autorun'

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new

require 'tps'

def f(*a)
  File.join fixture_root, *a
end

def fixture_root
  File.expand_path('../fixtures', __FILE__)
end
