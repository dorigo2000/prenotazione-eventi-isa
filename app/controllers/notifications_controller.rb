class NotificationsController < ApplicationController
  before_action :set_current_user
  before_action :require_login

  def index
    @notifications = Current.user.notifications.order(created_at: :desc)
    head :ok
  end

  def mark_as_read
    @notification = Notification.find(params[:id])
    @notification.update(letto: true)

    redirect_to events_path
  end

  private

  def require_login
    unless session[:user_id]
      redirect_to root_path
    end
  end
end
