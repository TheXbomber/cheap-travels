# Alessandro
class UsersController < ApplicationController
  def profile
    id = params[:id]
    @user = User.find(id)
  end

  def edit
    before_action :authenticate_user!
  end

  def add_to_favourites
    @user = User.find(current_user.id)
    str = @user.favourites + ","
    if @user.favourites != ""
      @user.update(favourites: str)
    end
    @user.save
    str = @user.favourites + params[:place]
    @user.update(favourites: str)
    @user.save
    redirect_back(fallback_location: root_path)
  end
end
