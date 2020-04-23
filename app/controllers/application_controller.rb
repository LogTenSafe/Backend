# @abstract
#
# Abstract superclass for LogTenSafe controllers. All requests are JSON
# formatted. Typical responses:
#
# ## Record not found
#
# The response will be a 404 Not Found.
#
# ## Unauthorized
#
# The response will be a 401 Unauthorized.
#
# ## Record failed validation
#
# The response will be a 422 Unprocessable Entity. The response body will be
# a dictionary mapping fields to an array of errors.

class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  before_bugsnag_notify :add_user_info_to_bugsnag
  before_action :authenticate_user!

  respond_to :json

  rescue_from(ActiveRecord::RecordNotFound) do |err|
    respond_to do |format|
      format.json { render json: {error: err.to_s}, status: :not_found }
      format.any { head :not_found }
    end
  end

  private

  def add_user_info_to_bugsnag(report)
    report.user = {
        id:   current_user.id,
        name: current_user.login
    } if user_signed_in?
  end
end
