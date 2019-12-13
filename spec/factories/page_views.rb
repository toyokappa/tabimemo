FactoryBot.define do
  factory :page_view do
    count { 1 }
    date { "2018-02-06" }
    plan_id { 1 }
  end
end
