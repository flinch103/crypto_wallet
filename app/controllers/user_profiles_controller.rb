# UserProfiles Controller
class UserProfilesController < ApplicationController
  before_action :authenticate_user!, except: [:check_email_uniqueness]

  def edit; end

  def update_avatar
    current_user.update(avatar: params[:user_profiles][:avatar])
    redirect_to edit_user_profile_path(current_user)
  end

  def check_email_uniqueness
    return render_success_response('success') unless User.exists?(email: params[:email].downcase)
    render_error_response('failure')
  end
             
end
  