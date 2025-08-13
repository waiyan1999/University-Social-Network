class CommentsController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    comment = post.comments.build(comment_params.merge(user: current_user))
    if comment.save
      create_notification!(actor: current_user, recipient: post.user, action: "commented", notifiable: comment) if post.user != current_user
      redirect_to post_path(post), notice: "Comment added."
    else
      redirect_to post_path(post), alert: "Comment cannot be blank."
    end
  end

  def destroy
    comment = current_user.comments.find(params[:id])
    comment.destroy
    redirect_back fallback_location: root_path, notice: "Comment removed."
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def create_notification!(actor:, recipient:, action:, notifiable:)
    Notification.create!(actor: actor, recipient: recipient, action: action, notifiable: notifiable)
  end
end
