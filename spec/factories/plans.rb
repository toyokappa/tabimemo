FactoryBot.define do
  factory :plan do
    name { Faker::Lorem.word }
    description { Faker::Lorem.paragraph }
    status { [0, 1].sample }
    view_count { Faker::Number.number(3) }
    user
  end
end
