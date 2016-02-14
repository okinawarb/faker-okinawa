module Faker
  module Okinawa
    class Fish
      FISH_DIC_PATH = File.expand_path('../../../o-dic/sakana.dic', __dir__)
      FISH_DIC = Faker::Okinawa::Odic.new(FISH_DIC_PATH)

      class << self
        def name
          FISH_DIC.entries.sample.word
        end
      end
    end
  end
end
