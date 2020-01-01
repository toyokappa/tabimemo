class Users::GotTrophyController < ApplicationController
  def update
    current_user.update!(got_trophy_name: nil)
    render status: 200, json: "ok"
  end
end
