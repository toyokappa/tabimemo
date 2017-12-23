include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :photo do
    image { fixture_file_upload("spec/fixtures/images/sample01.jpg", "image/jpg") }
    spot
  end
end
