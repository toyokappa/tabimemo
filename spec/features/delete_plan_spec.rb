require "rails_helper"

feature "プラン削除" do
  context "プランを作成したユーザーの場合" do
    given(:plan) { create(:plan, status: 1) }

    scenario "プランを削除できる" do
      sign_in plan.user
      expect(page).to have_link href: "/plans/#{plan.id}"
      visit plan_path(plan)
      click_link I18n.t("link.delete")
      expect(current_path).to eq users_plans_path
      expect(page).to have_content I18n.t("flash.delete_success")
      expect(page).not_to have_link href: "/plans/#{plan.id}"
    end
  end

  context "プラン作成したユーザーではない場合" do
    given(:plan) { create(:plan, status: 1) }
    given(:other) { create(:user) }

    scenario "プランを削除できない" do
      sign_in other
      visit plan_path(plan)
      expect(page).not_to have_content I18n.t("link.delete")
    end
  end
end
