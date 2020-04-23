# @private
class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    super { |user| @user = user } # render the JSON view
  end
end
