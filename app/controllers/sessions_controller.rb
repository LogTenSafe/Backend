# Controller for signing users in and out.

class SessionsController < ApplicationController
  skip_before_filter :login_required
  before_filter :must_be_unauthenticated, except: :destroy

  # Displays a login page. Supply a `next` query parameter to redirect the user
  # to a specific page after login.

  def new
    respond_to do |format|
      format.html # new.html.slim
      format.json { head :not_found }
    end
  end

  # Attempts to log a user in. If successful, redirects to the URL in the `next`
  # form parameter; or if not, re-renders the login form with the error.

  def create
    if (user = User.authenticate(params[:login], params[:password]))
      log_in user
      respond_to do |format|
        format.html { redirect_to(params[:next].presence || root_url) }
        format.json { head :ok }
      end
    else
      respond_to do |format|
        format.html do
          flash.now[:alert] = t('controllers.sessions.create.invalid')
          render 'new'
        end
        format.json { head :unauthorized }
      end
    end
  end

  # Logs the user out.

  def destroy
    log_out
    respond_to do |format|
      format.html { redirect_to root_url, notice: t('controllers.sessions.destroy.success') }
      format.json { head :no_content }
    end
  end
end
