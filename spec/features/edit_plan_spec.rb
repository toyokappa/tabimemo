require "rails_helper"

feature "プラン編集" do
  given(:plan) { create :plan }
  before do
    visit edit_plan_path(plan)
    fill_in "plan[name]", with: plan_name
    fill_in "plan[description]", with: plan_description
    fill_in "plan[spots_attributes][0][name]", with: spot_name
    fill_in "plan[spots_attributes][0][description]", with: spot_description
    click_button I18n.t("helpers.submit.update")
  end

  context "正しい値を入力した場合" do
    given(:plan_name) { Faker::Lorem.word }
    given(:plan_description) { Faker::Lorem.paragraph }
    given(:spot_name) { Faker::Address.city }
    given(:spot_description) { Faker::Lorem.paragraph }

    scenario "更新に成功する" do
      expect(page).to have_content I18n.t("flash.update_success")
      expect(page).to have_content plan_name
    end
  end

  context "プラン名が不正な場合" do
    given(:plan_name) { nil }
    given(:plan_description) { Faker::Lorem.paragraph }
    given(:spot_name) { Faker::Address.city }
    given(:spot_description) { Faker::Lorem.paragraph }

    scenario "更新に失敗する" do
      expect(page).to have_content I18n.t("errors.messages.empty")
    end
  end

  context "プラン説明が不正な場合" do
    given(:plan_name) { Faker::Lorem.word }
    given(:plan_description) { "a" * 1001 }
    given(:spot_name) { Faker::Address.city }
    given(:spot_description) { Faker::Lorem.paragraph }

    scenario "更新に失敗する" do
      expect(page).to have_content I18n.t("errors.messages.too_long", count: 1000)
    end
  end

  context "スポット名が不正な場合" do
    given(:plan_name) { Faker::Lorem.word }
    given(:plan_description) { Faker::Lorem.paragraph }
    given(:spot_name) { "a" * 51 }
    given(:spot_description) { Faker::Lorem.paragraph }

    scenario "更新に失敗する" do
      expect(page).to have_content I18n.t("errors.messages.too_long", count: 50)
    end
  end

  context "スポット説明が不正な場合" do
    given(:plan_name) { Faker::Lorem.word }
    given(:plan_description) { Faker::Lorem.paragraph }
    given(:spot_name) { Faker::Address.city }
    given(:spot_description) { "a" * 1001 }

    scenario "更新に失敗する" do
      expect(page).to have_content I18n.t("errors.messages.too_long", count: 1000)
    end
  end
end
