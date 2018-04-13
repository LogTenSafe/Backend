# @abstract
#
# Abstract superclass of all controllers in this application.

class ApplicationController < ActionController::Base
  include Authentication
  before_action :login_required

  before_action :set_storage_host

  rescue_from(ActiveRecord::RecordNotFound) do |err|
    respond_to do |format|
      format.html { render file: 'public/404.html', status: :not_found }
      format.json { render json: {error: err.to_s}, status: :not_found }
      format.any { head :not_found }
    end
  end

  private

  def set_storage_host
    # really only needed for DiskService in dev/test
    ActiveStorage::Current.host = request.base_url
  end
end
