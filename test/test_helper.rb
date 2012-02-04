$:.unshift File.expand_path('../../lib', __FILE__)
require 'contest'
require 'tps'

class UnitTest < Test::Unit::TestCase
  def f(*a)
    File.join fixture_root, *a
  end

  def fixture_root
    File.expand_path('../', __FILE__)
  end
end
