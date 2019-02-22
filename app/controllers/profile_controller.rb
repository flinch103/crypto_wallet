class ProfileController < ApplicationController
  before_action :authenticate_user!
  
  def index
  end

  def show
  end

  def update_avatar
    current_user.update(avatar: params[:avatar])
    redirect_to profile_path(current_user)
  end

  def update_name
    current_user.update(full_name: params[:profile][:full_name])
    redirect_to profile_path(current_user)
  end
end
