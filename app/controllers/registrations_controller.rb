# @private
class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    super { |user| @user = user } # render the JSON view
  end

  def sign_up(resource_name, resource)
    sign_in(resource_name, resource, store: false)
  end

  def bypass_sign_in(resource, scope: nil)
    # do nothing, no sessions
  end
end
