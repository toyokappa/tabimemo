include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :profile do
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    location { Faker::Address.city }
    url { Faker::Internet.url }
    birthday { Faker::Date.birthday(18,65) }
    image { fixture_file_upload("spec/fixtures/images/sample01.jpg", "image/jpg") }
    user
  end
end
