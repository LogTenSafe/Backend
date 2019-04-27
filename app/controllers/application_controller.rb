# @abstract
#
# Abstract superclass of all controllers in this application.

class ApplicationController < ActionController::Base
  include Authentication
  before_bugsnag_notify :add_user_info_to_bugsnag
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

  def add_user_info_to_bugsnag(report)
    report.user = {
        id:   current_user.id,
        name: current_user.login
    } if current_user
  end
end
