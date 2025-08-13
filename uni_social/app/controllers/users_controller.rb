class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def show
    @user    = User.find(params[:id])
    @profile = @user.profile
    @posts   = @user.posts.includes(photo_attachment: :blob).order(created_at: :desc)
  end
end
