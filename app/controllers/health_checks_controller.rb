# HealthChecks Controller
class HealthChecksController < ActionController::Base
  def health
    head :ok
  end
end
