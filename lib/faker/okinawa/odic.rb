module Faker
  module Okinawa
    class Odic
      COMMENT_OR_BLANK_REGEXP = /^\s*$|^\s*#.*$/

      attr_reader :entries

      Entry = Struct.new(:phonate, :word, :word_class, :comment) do
        MAX_PHONATE_LENGTH           = 40
        MAX_WORD_LENGTH              = 64
        INVALID_PHONATE_REGEXP       = /[^あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもらりるれろがぎぐげござじずぜぞだぢづでどばびぶべぼぁぃぅぇぉっょゃゅゎぱぴぷぺぽやゆよわをんヴー]/
        INVALID_WORD_REGEXP          = /[ \t",#]/
        ENTRY_WITH_COMMENT_REGEXP    = /^(\S+)\s+(\S+)\s+(\S+)\s+#\s*([[:^cntrl:]]*).*$/
        ENTRY_WITHOUT_COMMENT_REGEXP = /^(\S+)\s+(\S+)\s+(\S+)/

        def valid?
          phonate.length <  MAX_PHONATE_LENGTH &&
          word.length    <  MAX_WORD_LENGTH &&
          phonate        !~ INVALID_PHONATE_REGEXP &&
          word           !~ INVALID_WORD_REGEXP
        end

        def self.from_entry_line(entry_line)
          return if entry_line !~ ENTRY_WITH_COMMENT_REGEXP && entry_line !~ ENTRY_WITHOUT_COMMENT_REGEXP

          new($1, $2, $3, $4)
        end
      end

      def initialize(odic_path)
        entry_lines = File.readlines(odic_path).reject {|line|
          line =~ COMMENT_OR_BLANK_REGEXP
        }
        @entries = entry_lines.map {|entry_line|
          Entry.from_entry_line(entry_line)
        }.compact.select(&:valid?)
      end
    end
  end
end
