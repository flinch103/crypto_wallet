class CheckTransactionJob < ApplicationJob
  def perform(hash)
    data = RestClient.get(Figaro.env.NODE_APP_URL + "/#{hash}" + '/status')
    data = JSON.parse(data)
    return CheckTransactionJob.perform_later(hash) if data['status'] == 'PENDING'
    UpdateTransactionJob.perform_later(hash, data['status'])
  end
end