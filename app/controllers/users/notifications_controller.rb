class Users::NotificationsController < ApplicationController
  before_action :set_notification

  def edit
  end

  def update
    @notification.update!(notification_paramas)
    redirect_to edit_users_notification_path, notice: t(:update_success, scope: :flash)
  end

  private

    def set_notification
      @notification = current_user.notification
    end

    def notification_paramas
      params.require(:notification).permit(:when_like, :when_comment, :when_follow, :when_news)
    end
end
