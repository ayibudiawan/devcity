Apipie.configure do |config|
  config.app_name = "Devcity Friends Management API"
  config.app_info = "Devcity API - Use for test only"
  config.api_base_url = "/api/v1"
  config.doc_base_url = "/docs"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/v1/*.rb"
  config.translate = false
  config.default_locale = nil
  config.default_version = "1.0"
end
