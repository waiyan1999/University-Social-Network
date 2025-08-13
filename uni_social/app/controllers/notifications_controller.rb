# app/controllers/notifications_controller.rb
class NotificationsController < ApplicationController
  before_action :authenticate_user!, raise: false

  def index
    @notifications = current_user.received_notifications.recent.includes(:actor, :notifiable)
  end

  # Optional: mark one as read (PATCH /notifications/:id)
  def update
    notification = current_user.received_notifications.find(params[:id])
    notification.mark_as_read!
    redirect_to notifications_path, notice: "Marked as read."
  end

  # Optional: bulk mark all as read (POST /notifications/mark_all_read)
  def mark_all_read
    current_user.received_notifications.unread.update_all(read_at: Time.current)
    redirect_to notifications_path, notice: "All notifications marked as read."
  end
end
