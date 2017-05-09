module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
  end

  def log_in(user)
    session[:user_id] = user.id
    @current_user     = user
  end

  def log_out
    session[:user_id] = nil
    @current_user     = nil
  end

  protected

  def current_user
    @current_user ||= begin
      if request.format.html? || request.format.js?
        if session[:user_id].present?
          User.find_by_id(session[:user_id])
        else
          nil
        end
      else
        authenticate_with_http_basic { |u, p| User.authenticate(u, p) } ||
          request_http_basic_authentication
      end
    end
  end

  def login_required
    if current_user
      return true
    else
      respond_to do |format|
        format.html do
          # don't show the login message if we landed on the root URL
          flash[:notice] = t('controllers.authentication.login_required') unless request.fullpath == root_path
          redirect_to login_url(next: request.fullpath)
        end
        format.any { head :unauthorized }
      end
      return false
    end
  end

  def must_be_unauthenticated
    if current_user
      respond_to do |format|
        format.html { redirect_to root_url }
        format.any { head :forbidden }
      end
      return false
    else
      return true
    end
  end
end
