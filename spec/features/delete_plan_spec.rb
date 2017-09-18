require "rails_helper"

feature "プラン削除" do
  before { @plan = create(:plan) }

  scenario "削除に成功する" do
    visit root_path
    expect(page).to have_link href: "/plans/#{@plan.id}"
    visit plan_path(@plan)
    click_link I18n.t("link.delete")
    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t("flash.delete_success")
    expect(page).not_to have_link href: "/plans/#{@plan.id}"
  end
end
