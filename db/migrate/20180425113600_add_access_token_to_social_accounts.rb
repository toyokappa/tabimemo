class AddAccessTokenToSocialAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :social_accounts, :access_token, :string
    add_column :social_accounts, :access_secret, :string
  end
end
