# coding: utf-8
require "test_helper"

class HelperTest < Faker::Okinawa::TestCase
  def test_word?
    assert  word?("English")
    assert  word?("日本語")

    assert !word?(""),               "should at least one character"
    assert !word?("Boy meets girl"), "should not contain any spaces"
    assert !word?(" "),              "should not spaces"
  end
end
