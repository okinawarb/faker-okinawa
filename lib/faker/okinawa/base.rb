module Faker
  module Okinawa
    class Base
      BASE_DIC_PATH = File.expand_path('../../../o-dic/base.dic', __dir__)
      BASE_DIC = Faker::Okinawa::Odic.new(BASE_DIC_PATH)

      class << self
        def name
          BASE_DIC.entries.sample.word
        end
      end
    end
  end
end
