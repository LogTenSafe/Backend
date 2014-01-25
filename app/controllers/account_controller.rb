# RESTful singleton controller for managing the current {User}'s account.

class AccountController < ApplicationController
  respond_to :html

  # Displays a form where a user can modify his/her account.

  def edit
    respond_with current_user
  end

  # Modifies a user's account.

  def update
    current_user.update_attributes account_params
    flash[:success] = t('controllers.account.update.success') if current_user.valid?
    respond_with current_user, location: edit_account_url
  end

  # Deletes a user's account.

  def destroy
    current_user.destroy
    log_out

    respond_to do |format|
      format.html { redirect_to root_url, notice: t('controllers.account.destroy.success') }
      format.any { head :no_content }
    end
  end

  private

  def account_params
    params.require(:user).permit(:login, :password, :password_confirmation)
  end
end
