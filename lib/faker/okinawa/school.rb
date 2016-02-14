module Faker
  module Okinawa
    class School
      SCHOOL_DIC_PATH = File.expand_path('../../../o-dic/school.dic', __dir__)
      SCHOOL_DIC = Faker::Okinawa::Odic.new(SCHOOL_DIC_PATH)

      class << self
        def name
          SCHOOL_DIC.entries.sample.word
        end
      end
    end
  end
end
