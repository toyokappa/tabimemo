require "rails_helper"

feature "プラン管理" do
  context "複数のユーザーがプランを投稿している場合" do
    given(:user) { create :user }
    given(:other) { create :user }
    before do
      @user_plans = create_list(:plan, 5, user: user, status: 1)
      @other_plans = create_list(:plan, 5, user: other, status: 1)
      sign_in user
      visit users_plans_path
    end

    scenario "管理画面には自分の登録したレコードのみ表示される" do
      @user_plans.each { |plan| expect(page).to have_link href: "/plans/#{plan.id}" }
      @other_plans.each { |plan| expect(page).not_to have_link href: "/plans/#{plan.id}" }
    end
  end

  context "登録件数が10件の場合" do
    given(:user) { create :user }
    before do
      @plans = create_list(:plan, 10, user: user, status: 0)
      sign_in user
      visit users_plans_path
    end

    scenario "1ページに全レコードが表示される" do
      @plans.each { |plan| expect(page).to have_link href: "/plans/#{plan.id}" }
      expect(page).not_to have_link href: "/users/plan/?page=2"
    end
  end

  context "登録件数が11件の場合" do
    given(:user) { create :user }
    before do
      @plan = create_list(:plan, 11, user: user, status: 0)
      sign_in user
      visit users_plans_path
    end

    scenario "2ページに分割してレコードが表示される" do
      expect(page).to have_link href: "/plans/#{@plan.first.id}"
      expect(page).not_to have_link href: "/plans/#{@plan.last.id}"
      expect(page).to have_link href: "/users/plans?page=2"
    end
  end
end
