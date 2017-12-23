FactoryGirl.define do
  factory :user do
    email { Faker::Internet.unique.email }
    name { Faker::Internet.user_name(1..15) }
    password "password"
  end
end
