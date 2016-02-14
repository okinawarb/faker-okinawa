module Faker
  module Okinawa
    class Awamori
      AWAMORI_DIC_PATH = File.expand_path('../../../o-dic/awamori.dic', __dir__)
      AWAMORI_DIC = Faker::Okinawa::Odic.new(AWAMORI_DIC_PATH)

      class << self
        def name
          AWAMORI_DIC.entries.sample.word
        end
      end
    end
  end
end
