class LikesController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    like = post.likes.find_or_initialize_by(user: current_user)
    if like.persisted?
      redirect_back fallback_location: root_path
    else
      like.save!
      create_notification!(actor: current_user, recipient: post.user, action: "liked", notifiable: like) if post.user != current_user
      redirect_back fallback_location: root_path
    end
  end

  def destroy
    post = Post.find(params[:post_id])
    like = post.likes.find_by!(user: current_user)
    like.destroy
    if post.user != current_user
      Notification.create!(actor: current_user, recipient: post.user, action: "unliked", notifiable: post)
    end
    redirect_back fallback_location: root_path
  end

  private

  def create_notification!(actor:, recipient:, action:, notifiable:)
    Notification.create!(actor: actor, recipient: recipient, action: action, notifiable: notifiable)
  end
end
