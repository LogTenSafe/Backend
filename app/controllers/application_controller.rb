# @abstract
#
# Abstract superclass of all controllers in this application.

class ApplicationController < ActionController::Base
  include Authentication
  before_filter :login_required

  protect_from_forgery with: :exception

  rescue_from(ActiveRecord::RecordNotFound) do |err|
    respond_to do |format|
      format.html { render file: 'public/404.html', status: :not_found }
      format.json { render json: { error: err.to_s }, status: :not_found }
      format.any { head :not_found }
    end
  end
end
