FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    name { Faker::Internet.user_name }
    password { "password" }
  end
end
