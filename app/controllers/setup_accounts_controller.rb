# SetupAccounts Controller
class SetupAccountsController < ApplicationController
  layout 'setup_accounts'
  def index
    page_name = params[:page_name]
    render page_name
  end

  def setup; end
end
