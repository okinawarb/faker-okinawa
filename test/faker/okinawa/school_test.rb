require 'test_helper'

class SchoolTest < Faker::Okinawa::TestCase
  def setup
    @tester = Faker::Okinawa::School
  end

  def test_name
    assert word?(@tester.name)
  end
end
