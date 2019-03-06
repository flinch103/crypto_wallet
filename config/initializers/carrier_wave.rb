CarrierWave.configure do |config|
  config.fog_provider = Figaro.env.FOG_PROVIDER # required
  config.fog_credentials = {
    provider: ENV['PROVIDER'], # required
    google_storage_access_key_id: ENV['ACCESS_KEY'], # required
    google_storage_secret_access_key: ENV['SECRET_KEY'], # required
  }
  config.fog_directory  = ENV['FOG_DIR'] # required
end if ENV['UPLOADER_STORAGE_PATH'] == 'fog'