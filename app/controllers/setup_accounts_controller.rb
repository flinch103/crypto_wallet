# SetupAccounts Controller
class SetupAccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_wallet_setup
  layout 'setup_accounts'
  def index
    page_name = params[:page_name]
    render page_name
  end

  def setup; end

  private

  def check_wallet_setup
    unless current_user.arbiter?
      return redirect_to root_path if current_user.platform_stack_tx.present?
    end
  end

end
