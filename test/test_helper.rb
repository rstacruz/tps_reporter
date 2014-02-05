$:.unshift File.expand_path('../../lib', __FILE__)
require 'minitest/autorun'
require 'tps'

def f(*a)
  File.join fixture_root, *a
end

def fixture_root
  File.expand_path('../fixtures', __FILE__)
end
