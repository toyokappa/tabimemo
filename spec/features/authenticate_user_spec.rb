require "rails_helper"

feature "ユーザー認証" do
  feature "ログイン" do
    before do
      visit root_path
      click_link I18n.t("menu.sign_in")
      fill_in "user[login]", with: user_login
      fill_in "user[password]", with: user_password
      click_button I18n.t("users.sessions.new.title")
    end

    context "正しい値を入力した場合（ユーザー名)" do
      given(:user) { create(:user) }
      given(:user_login) { user.name }
      given(:user_password) { user.password }

      scenario "ログインに成功する" do
        expect(page).to have_content I18n.t("devise.sessions.signed_in")
        expect(page).to have_content I18n.t("menu.sign_out")
        expect(current_path).to eq root_path
      end
    end
    
    context "正しい値を入力した場合（メールアドレス)" do
      given(:user) { create(:user) }
      given(:user_login) { user.email }
      given(:user_password) { user.password }

      scenario "ログインに成功する" do
        expect(page).to have_content I18n.t("devise.sessions.signed_in")
        expect(page).to have_content I18n.t("menu.sign_out")
        expect(current_path).to eq root_path
      end
    end

    context "登録されていないユーザー名の場合" do
      given(:user) { create(:user) }
      given(:user_login) { "invalid_user_name" }
      given(:user_password) { user.password }

      scenario "ログインに失敗する" do
        expect(page).to have_content I18n.t("devise.failure.not_found_in_database")
        expect(current_path).to eq new_user_session_path
      end
    end

    context "登録されていないメールアドレスの場合" do
      given(:user) { create(:user) }
      given(:user_login) { "invalid_user_name@test.con" }
      given(:user_password) { user.password }

      scenario "ログインに失敗する" do
        expect(page).to have_content I18n.t("devise.failure.not_found_in_database")
        expect(current_path).to eq new_user_session_path
      end
    end

    context "登録されていないパスワードの場合" do
      given(:user) { create(:user) }
      given(:user_login) { user.name }
      given(:user_password) { "invalid_password" }

      scenario "ログインに失敗する" do
        expect(page).to have_content I18n.t("devise.failure.invalid")
        expect(current_path).to eq new_user_session_path
      end
    end
  end

  feature "ログアウト" do
    given(:user) { create(:user) }
    scenario "ログアウトに成功する" do
      sign_in user
      click_link I18n.t("menu.sign_out")
      expect(page).to have_content I18n.t("devise.sessions.signed_out")
      expect(page).to have_content I18n.t("menu.sign_in")
    end
  end
end
