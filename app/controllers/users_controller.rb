# RESTful controller for {User} instances. Powers the signup page.

class UsersController < ApplicationController
  skip_before_filter :login_required
  respond_to :html

  # Displays a signup page.

  def new
    @user = User.new
    respond_with @user
  end

  # Creates a new user and takes him/her to the login page.

  def create
    @user = User.create(user_params)
    flash[:success] = t('controllers.users.create.success') if @user.valid?
    respond_with @user, location: login_url
  end

  private

  def user_params
    params.require(:user).permit(:login, :password, :password_confirmation)
  end
end
