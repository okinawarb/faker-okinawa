require 'test_helper'

class NameTest < Faker::Okinawa::TestCase
  def setup
    @tester = Faker::Okinawa::Name
  end

  def test_last_name
    assert word?(@tester.last_name)
  end
end
