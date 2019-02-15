# Responsible to create wallet
# :reek:InstanceVariableAssumption
class Wallets::CreateIntr < ActiveInteraction::Base
  object :user
  string :address
  float :balance, default: 0.0

  validates :address, presence: true

  def execute
    create_wallet
    @wallet
  end

  private

  def create_wallet
    return errors.add(:base, I18n.t('wallet.create.already')) if already_found?

    wallet.address = address
    errors.merge! wallet.errors unless wallet.save
  end

  def wallet
    @wallet ||= Wallet.find_or_initialize_by(user_id: user.id)
  end

  def already_found?
    Wallet.find_by(address: address).present? || wallet.persisted?
  end
end
