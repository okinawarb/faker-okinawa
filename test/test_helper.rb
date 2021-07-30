$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "faker/okinawa"
require "minitest/autorun"

class Faker::Okinawa::TestCase < MiniTest::Test
  def word?(str)
    str.class == String && str.match(/^[^ \t\n]+$/)
  end
end
