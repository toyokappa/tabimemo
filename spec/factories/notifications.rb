FactoryGirl.define do
  factory :notification do
    when_like false
    when_comment false
    when_news false
    user_id 1
  end
end
