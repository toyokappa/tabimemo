FactoryGirl.define do
  factory :plan do
    name { Faker::Lorem.word }
    description { Faker::Lorem.paragraph }
    published { [true, false].sample }
    view_count { Faker::Number.number(3) }
  end
end
