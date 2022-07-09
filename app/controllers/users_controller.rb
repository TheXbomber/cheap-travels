class UsersController < ApplicationController
  def profile
    id = params[:id]
    @user = User.find(id)
    @hide_user = true
  end

  def edit
    before_action :authenticate_user!
  end

  def promote_to_moderator
    id = params[:uid]
    @user = User.find(id)
    @user.update(role: "moderator")
    @user.save
    redirect_back(fallback_location: root_path)
  end

  def demote_to_user
    id = params[:uid]
    @user = User.find(id)
    @user.update(role: "user")
    @user.save
    redirect_back(fallback_location: root_path)
  end

  def ban_user
    id = params[:uid]
    @user = User.find(id)
    @user.update(banned: true)
    @user.save
    redirect_back(fallback_location: root_path)
  end

  def unban_user
    id = params[:uid]
    @user = User.find(id)
    @user.update(banned: false)
    @user.save
    redirect_back(fallback_location: root_path)
  end
end
