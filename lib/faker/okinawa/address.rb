module Faker
  module Okinawa
    class Address
      ADDRESS_DIC_PATH = File.expand_path('../../../o-dic/address.dic', __dir__)
      ADDRESS_DIC = Faker::Okinawa::Odic.new(ADDRESS_DIC_PATH)

      CITY_DIC_PATH = File.expand_path('../../../o-dic/city.dic', __dir__)
      CITY_DIC = Faker::Okinawa::Odic.new(CITY_DIC_PATH)

      ISLAND_DIC_PATH = File.expand_path('../../../o-dic/island.dic', __dir__)
      ISLAND_DIC = Faker::Okinawa::Odic.new(ISLAND_DIC_PATH)

      PARK_DIC_PATH = File.expand_path('../../../o-dic/park.dic', __dir__)
      PARK_DIC = Faker::Okinawa::Odic.new(PARK_DIC_PATH)

      class << self
        def city
          CITY_DIC.entries.sample.word
        end

        def district
          ADDRESS_DIC.entries.sample.word
        end

        def island
          ISLAND_DIC.entries.sample.word
        end

        def park
          PARK_DIC.entries.sample.word
        end
      end
    end
  end
end
