class API::BaseController < ActionController::Base
  skip_before_action :verify_authenticity_token
  layout 'response'
  respond_to :json
end
