FactoryGirl.define do
  factory :spot do
    name { Faker::Address.city }
    description { Faker::Lorem.paragraph }
    address { Faker::Lorem.sentence }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    required_time { Faker::Number.number(3) }
    plan
  end
end
