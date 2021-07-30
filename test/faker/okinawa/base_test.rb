require 'test_helper'

class BaseTest < Faker::Okinawa::TestCase
  def setup
    @tester = Faker::Okinawa::Base
  end

  def test_name
    assert word? @tester.name
  end
end
