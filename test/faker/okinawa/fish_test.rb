require 'test_helper'

class FishTest < Faker::Okinawa::TestCase
  def setup
    @tester = Faker::Okinawa::Fish
  end

  def test_name
    assert word? @tester.name
  end
end
