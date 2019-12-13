require "factory_bot"

15.times do
  FactoryBot.create(:plan) do |plan|
    FactoryBot.create_list(:spot, 3, plan: plan)
  end
end
