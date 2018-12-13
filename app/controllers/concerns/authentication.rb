# Mixin that adds controller methods for logging the user in and out.

module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
  end

  # Logs in a user. Assumes the user has already been authenticated.
  #
  # @param [User] user The user to log in as.

  def log_in(user)
    session[:user_id] = user.id
    @current_user     = user
  end

  # Logs out the current user.

  def log_out
    session[:user_id] = nil
    @current_user     = nil
  end

  protected

  # @return [User, nil] The currently logged-in user, or `nil` if there is no
  #   active user session.

  def current_user
    @current_user ||= begin
      if request.format.html? || request.format.js?
        User.find_by_id(session[:user_id]) if session[:user_id].present?
      else
        authenticate_with_http_basic { |u, p| User.authenticate(u, p) } ||
          request_http_basic_authentication
      end
    end
  end

  # `before_action` that requires a logged-in user.

  def login_required
    return true if current_user

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

  # `before_action` that forbids logged in users from seeing a page.

  def must_be_unauthenticated
    return true unless current_user

    respond_to do |format|
      format.html { redirect_to root_url }
      format.any { head :forbidden }
    end
    return false
  end
end
