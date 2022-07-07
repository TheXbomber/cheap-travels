# Alessandro
class UsersController < ApplicationController
  def profile
    id = params[:id]
    @user = User.find(id)
  end

  def edit
    before_action :authenticate_user!
  end
end
