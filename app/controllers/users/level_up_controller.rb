class Users::LevelUpController < ApplicationController
  def update
    current_user.update!(level_up: false)
    render status: 200, json: "ok"
  end
end
