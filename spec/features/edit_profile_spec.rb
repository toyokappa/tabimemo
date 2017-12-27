require "rails_helper"

feature "プロフィール" do
  feature "プロフィール登録" do
    given(:user) { create :user }
    before do
      sign_in user
      visit new_users_profile_path
      attach_file "profile[image]", image
      fill_in "profile[name]", with: name
      fill_in "profile[description]", with: description
      fill_in "profile[location]", with: location
      fill_in "profile[url]", with: url
      select gender, from: "profile[gender]"
      select birthday.year, from: "profile[birthday(1i)]"
      select birthday.month, from: "profile[birthday(2i)]"
      select birthday.day, from: "profile[birthday(3i)]"
      click_button I18n.t("helpers.submit.create")
    end

    context "正しい値を入力した場合" do
      given(:image) { Rails.root.join("spec", "fixtures", "images", "sample01.jpg") }
      given(:name) { Faker::Name.name }
      given(:description) { Faker::Lorem.paragraph }
      given(:location) { Faker::Address.city }
      given(:url) { Faker::Internet.url }
      given(:gender) { ["男性", "女性"].sample }
      given(:birthday) { Faker::Date.birthday(18, 65) }

      scenario "プロフィール編集に成功する" do
        expect(page).to have_content I18n.t("flash.register_success")
        expect(current_path).to eq user_profile_path(user.name)
        expect(page).to have_content name
      end
    end

    context "不正な画像を登録した場合" do
      given(:image) { Rails.root.join("spec", "fixtures", "images", "sample03.jpg") }
      given(:name) { Faker::Name.name }
      given(:description) { Faker::Lorem.paragraph }
      given(:location) { Faker::Address.city }
      given(:url) { Faker::Internet.url }
      given(:gender) { ["男性", "女性"].sample }
      given(:birthday) { Faker::Date.birthday(18, 65) }

      scenario "プロフィール編集に失敗する" do
        expect(page).to have_content I18n.t("errors.messages.max_file_size_error")
        expect(current_path).to eq users_profile_path
      end
    end
  end
end
