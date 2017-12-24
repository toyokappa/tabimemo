require "rails_helper"

feature "ユーザー編集" do
  feature "ユーザー情報" do
    given(:user) { create(:user) }
    before do
      sign_in user
      click_link I18n.t("menu.user_info")
      fill_in "user[name]", with: name
      fill_in "user[email]", with: email
      click_button I18n.t("helpers.submit.update")
    end

    context "正しい値を入力した場合" do
      given(:name) { Faker::Internet.user_name(1..15) }
      given(:email) { Faker::Internet.unique.email }

      scenario "更新に成功する" do
        expect(page).to have_content I18n.t("devise.registrations.updated")
        expect(current_path).to eq root_path
      end
    end

    context "ユーザー名が不正な場合" do
      given(:name) { nil }
      given(:email) { Faker::Internet.unique.email }

      scenario "更新に失敗する" do
        expect(page).to have_content I18n.t("errors.messages.empty")
        expect(current_path).to eq user_registration_path
      end
    end

    context "メールアドレスが不正な場合" do
      given(:name) { Faker::Internet.user_name(1..15) }
      given(:email) { nil }

      scenario "更新に失敗する" do
        expect(page).to have_content I18n.t("errors.messages.empty")
        expect(current_path).to eq user_registration_path
      end
    end
  end

  feature "パスワード変更" do
    given(:user) { create(:user) }
    before do
      sign_in user
      click_link I18n.t("menu.edit_password")
      fill_in "user[current_password]", with: current_password
      fill_in "user[password]", with: password
      fill_in "user[password_confirmation]", with: password_confirmation
      click_button I18n.t("helpers.submit.update")
    end

    context "正しい値を入力した場合" do
      given(:current_password) { user.password }
      given(:password) { "password" }
      given(:password_confirmation) { "password" }

      scenario "更新に成功する" do
        expect(page).to have_content I18n.t("flash.update_success")
        expect(current_path).to eq root_path
      end
    end

    context "現在のパスワードが不正の場合" do
      given(:current_password) { nil }
      given(:password) { "password" }
      given(:password_confirmation) { "password" }

      scenario "更新に失敗する" do
        expect(page).to have_content I18n.t("errors.messages.empty")
        expect(current_path).to eq users_password_path
      end
    end

    context "新しいパスワードが不正の場合（未入力）" do
      given(:current_password) { user.password }
      given(:password) { nil }
      given(:password_confirmation) { nil }

      scenario "更新に失敗する" do
        expect(page).to have_content I18n.t("errors.messages.empty")
        expect(current_path).to eq users_password_path
      end
    end

    context "新しいパスワードが不正の場合（不一致)" do
      given(:current_password) { user.password }
      given(:password) { "foobar" }
      given(:password_confirmation) { "foobaz" }

      scenario "更新に失敗する" do
        expect(page).to have_content I18n.t("errors.messages.confirmation", attribute: User.human_attribute_name(:password))
        expect(current_path).to eq users_password_path
      end
    end
  end
end
