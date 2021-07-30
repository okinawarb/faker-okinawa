require 'test_helper'

class FoodTest < Faker::Okinawa::TestCase
  def setup
    @tester = Faker::Okinawa::Food
  end

  def test_name
    assert word? @tester.name
  end
end
