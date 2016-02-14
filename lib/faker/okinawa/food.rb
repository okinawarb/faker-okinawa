module Faker
  module Okinawa
    class Food
      FOOD_DIC_PATH = File.expand_path('../../../o-dic/food.dic', __dir__)
      FOOD_DIC = Faker::Okinawa::Odic.new(FOOD_DIC_PATH)

      class << self
        def name
          FOOD_DIC.entries.sample.word
        end
      end
    end
  end
end
