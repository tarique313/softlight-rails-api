class ApplicationController < ActionController::API
  def api_error(status, title, detail)
    render json: {
      errors: [
        {
          status: status,
          title: title,
          detail: detail
        }
      ]
    }, status: status
  end
end
