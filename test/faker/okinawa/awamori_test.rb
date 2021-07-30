require 'test_helper'

class AwamoriTest < Faker::Okinawa::TestCase
  def setup
    @tester = Faker::Okinawa::Awamori
  end

  def test_name
    assert word? @tester.name
  end
end
