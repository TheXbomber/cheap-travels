class UsersController < ApplicationController
  def profile
    id = params[:id]
    @user = User.find(id)
    @hide_user = true
  end

  def edit
    before_action :authenticate_user!
  end
end
