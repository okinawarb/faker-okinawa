require 'test_helper'

class AddressTest < Faker::Okinawa::TestCase
  def setup
    @tester = Faker::Okinawa::Address
  end

  def test_city
    assert word? @tester.city
  end

  def test_district
    assert word? @tester.district
  end

  def test_island
    assert word? @tester.island
  end

  def test_park
    assert word? @tester.park
  end
end
