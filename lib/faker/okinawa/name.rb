module Faker
  module Okinawa
    class Name
      NAME_DIC_PATH = File.expand_path('../../../o-dic/name.dic', __dir__)
      NAME_DIC = Faker::Okinawa::Odic.new(NAME_DIC_PATH)

      class << self
        def last_name
          NAME_DIC.entries.sample.word
        end
      end
    end
  end
end
