require "rails_helper"

feature "ユーザーの登録" do
  before do
    visit root_path
    click_link I18n.t("menu.sign_up")
    fill_in "user[name]", with: user_name
    fill_in "user[email]", with: user_email
    fill_in "user[password]", with: user_password
    fill_in "user[password_confirmation]", with: user_password_confirmation
    click_button I18n.t("helpers.submit.create")
  end

  context "正しい値を入力した場合" do
    given(:user_name) { Faker::Internet.user_name(1..15) }
    given(:user_email) { Faker::Internet.unique.email }
    given(:user_password) { "password" }
    given(:user_password_confirmation) { "password" }

    scenario "登録に成功する" do
      expect(page).to have_content I18n.t("devise.registrations.signed_up")
      expect(current_path).to eq root_path
      expect(page).to have_content I18n.t("menu.sign_out")
    end
  end

  context "ユーザー名が不正な場合" do
    given(:user_name) { nil }
    given(:user_email) { Faker::Internet.unique.email }
    given(:user_password) { "password" }
    given(:user_password_confirmation) { "password" }

    scenario "登録に失敗する" do
      expect(page).to have_content I18n.t("errors.messages.empty")
      expect(current_path).to eq user_registration_path
    end
  end

  context "メールアドレスが不正な場合" do
    given(:user_name) { Faker::Internet.user_name(1..15) }
    given(:user_email) { nil }
    given(:user_password) { "password" }
    given(:user_password_confirmation) { "password" }

    scenario "登録に失敗する" do
      expect(page).to have_content I18n.t("errors.messages.empty")
      expect(current_path).to eq user_registration_path
    end
  end

  context "パスワードが不正な場合（未入力）" do
    given(:user_name) { Faker::Internet.user_name(1..15) }
    given(:user_email) { Faker::Internet.unique.email }
    given(:user_password) { nil }
    given(:user_password_confirmation) { nil }

    scenario "登録に失敗する" do
      expect(page).to have_content I18n.t("errors.messages.empty")
      expect(current_path).to eq user_registration_path
    end
  end

  context "パスワードが不正な場合（不一致）" do
    given(:user_name) { Faker::Internet.user_name(1..15) }
    given(:user_email) { Faker::Internet.unique.email }
    given(:user_password) { "foobar" }
    given(:user_password_confirmation) { "foobaz" }

    scenario "登録に失敗する" do
      expect(page).to have_content I18n.t("errors.messages.confirmation", attribute: User.human_attribute_name(:password))
      expect(current_path).to eq user_registration_path
    end
  end
end
