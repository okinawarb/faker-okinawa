require "test_helper"

class FakerOkinawaTest < Faker::Okinawa::TestCase
  def test_that_it_has_a_version_number
    refute_nil Faker::Okinawa::VERSION
  end
end
