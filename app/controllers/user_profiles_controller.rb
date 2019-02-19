# UserProfiles Controller
class UserProfilesController < ActionController::Base
  before_action :authenticate_user!

  def edit; end

  def update_avatar
    current_user.update(avatar: params[:user_profiles][:avatar])
    redirect_to edit_user_profile_path(current_user)
  end  
             
end
  