require "factory_girl"

15.times do
  FactoryGirl.create(:plan) do |plan|
    FactoryGirl.create_list(:spot, 3, plan: plan)
  end
end
