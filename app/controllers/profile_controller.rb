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

  def update
    if params[:user][:full_name].blank?
      flash[:error] = "Full name can't be blank"
      return redirect_to profile_path(current_user)
    end
    current_user.update(full_name: params[:user][:full_name])
    flash[:notice] = "Profile updated successfully"
    redirect_to profile_path(current_user)
  end
end
