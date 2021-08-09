# coding: utf-8
require 'test_helper'

class OdicTest < Faker::Okinawa::TestCase

  def test_normal
    odic = Faker::Okinawa::Odic.new(dic_path("normal_entries.dic"))

    assert_equal Faker::Okinawa::Odic::Entry.new("まちかじ", "松風", "普通名詞", "菓子"),
                 odic.entries[0]
  end

  def test_comment
    odic = Faker::Okinawa::Odic.new(dic_path("comment.dic"))

    # ignore comment line
    assert_equal 23, File.readlines(dic_path("comment.dic"), encoding: 'utf-8').length
    assert_equal  5, odic.entries.size

    # tail comment
    assert_equal "picked up",      odic.entries[0].comment
    assert                        !odic.entries[1].comment

    # trivial comment rules
    assert_equal "亜",             odic.entries[2].word_class
    assert_equal "コメント１",     odic.entries[2].comment
    assert_equal "亜#",            odic.entries[3].word_class
    assert                        !odic.entries[3].comment   
    assert_equal "亜#コメント３",  odic.entries[4].word_class
    assert                        !odic.entries[4].comment   
  end

  def test_empty
    odic = Faker::Okinawa::Odic.new(dic_path("empty.dic"))
    assert_equal 0, odic.entries.size
  end

  def test_entry_from_entry_line
    # match ENTRY_WITH_COMMENT_REGEXP
    entry = Faker::Okinawa::Odic::Entry.from_entry_line('1 2 3 #4')
    assert_equal "1",  entry.phonate
    assert_equal "2",  entry.word
    assert_equal "3",  entry.word_class
    assert_equal "4",  entry.comment

    # match ENTRY_WITHOUT_COMMENT_REGEXP
    entry = Faker::Okinawa::Odic::Entry.from_entry_line('1 2 3')
    assert_equal "1",  entry.phonate
    assert_equal "2",  entry.word
    assert_equal "3",  entry.word_class
    assert            !entry.comment

    # doesn't match both regex(ENTRY_WITH_COMMENT_REGEXP, ENTRY_WITHOUT_COMMENT_REGEXP)
    entry = Faker::Okinawa::Odic::Entry.from_entry_line('')
    assert            !entry
  end

  def test_entry_valid?
    # length(phonate: 40)
    assert   !Faker::Okinawa::Odic::Entry.new('あ' * 40, 'い' * 63, 'う', nil).valid?
    # length(word:    64)    
    assert   !Faker::Okinawa::Odic::Entry.new('あ' * 39, 'い' * 64, 'う', nil).valid?

    # character type(:phonate)
    assert   !Faker::Okinawa::Odic::Entry.new('亜',      'い',      'う', nil).valid?
    # character type(:word)
    " \t\",#".each_char do |char|      
      assert !Faker::Okinawa::Odic::Entry.new('あ',       char,     'う', nil).valid?
    end
  end

  private

    def dic_path(dic_name)
      File.expand_path("../../fixtures/" + dic_name, __dir__)
    end
end
