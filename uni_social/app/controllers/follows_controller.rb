class FollowsController < ApplicationController
  def create
    user = User.find(params[:user_id])
    current_user.active_follows.find_or_create_by!(followed: user)
    Notification.create!(actor: current_user, recipient: user, action: "followed", notifiable: current_user) if user != current_user
    redirect_back fallback_location: user_path(user)
  end

  def destroy
    user = User.find(params[:user_id])
    current_user.active_follows.where(followed: user).destroy_all
    redirect_back fallback_location: user_path(user)
  end
end
