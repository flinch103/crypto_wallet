class Users::SessionsController < Devise::SessionsController
  protect_from_forgery with: :null_session
  private

  def after_sign_out_path_for(resource)
    new_user_session_path
  end

end