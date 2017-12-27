require "rails_helper"

feature "プラン一覧" do
  context "登録件数が10件の場合" do
    given(:user) { create :user }
    before do
      @plans = create_list(:plan, 10, user: user, status: 1)
      visit root_path
    end

    scenario "1ページに全レコードが表示される" do
      @plans.each { |plan| expect(page).to have_link href: "/plans/#{plan.id}" }
      expect(page).not_to have_link href: "/?page=2"
    end
  end

  context "登録件数が11件の場合" do
    given(:user) { create :user }
    before do
      @plan = create_list(:plan, 11, user: user, status: 1)
      visit root_path
    end

    scenario "2ページに分割してレコードが表示される" do
      expect(page).to have_link href: "/plans/#{@plan.first.id}"
      expect(page).not_to have_link href: "/plans/#{@plan.last.id}"
      expect(page).to have_link href: "/?page=2"
    end
  end
end
