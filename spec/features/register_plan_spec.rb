require "rails_helper"

feature "プラン登録" do
  given(:user) { create(:user) }
  before do
    sign_in user
    visit new_users_plan_path
    fill_in "plan[name]", with: plan_name
    fill_in "plan[description]", with: plan_description
    click_button I18n.t("form.register_plan")
  end

  context "正しい値を入力した場合" do
    given(:plan_name) { Faker::Lorem.word }
    given(:plan_description) { Faker::Lorem.paragraph }

    scenario "登録に成功する" do
      expect(current_path).to eq edit_users_plan_path(user.plans.first)
      expect(page).to have_content plan_description
    end
  end

  context "プラン名が不正な場合" do
    given(:plan_name) { nil }
    given(:plan_description) { Faker::Lorem.paragraph }

    scenario "登録に失敗する" do
      expect(page).to have_content I18n.t("errors.messages.empty")
    end
  end

  context "プラン説明が不正な場合" do
    given(:plan_name) { Faker::Lorem.word }
    given(:plan_description) { "a" * 1001 }

    scenario "登録に失敗する" do
      expect(page).to have_content I18n.t("errors.messages.too_long", count: 1000)
    end
  end
end
