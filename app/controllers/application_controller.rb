# Application Controller control throughout the application.
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[full_name username role email])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[full_name username role email])
  end

  private

  # :reek:NilCheck
  def after_sign_in_path_for(resource)
    unless resource.role.eql?(params.dig(:user)&.dig(:role))
      sign_out resource
      flash.delete(:notice)
      set_flash_message!(:error, :role_not_match)
      return new_user_session_path
    end
    root_path
  end

  def after_sign_out_path_for(*)
    new_user_session_path
  end
  
  def check_wallet_setup
    unless current_user.arbiter?
      return redirect_to setup_accounts_path(:policy) if current_user.wallet.blank?
      return redirect_to setup_accounts_path(:platform_stack) if current_user.platform_stack_tx.blank?
    end
  end
end
