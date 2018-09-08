class Api::V1::ErrorsController < API::BaseController
  def routing
    render json: {message: 'Routing Error'}, status: 400
  end
end
