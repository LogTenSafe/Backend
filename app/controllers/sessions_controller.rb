# @private
class SessionsController < Devise::SessionsController
  respond_to :json

  private

  def sign_in(resource_or_scope, *args)
    options = args.extract_options!
    super resource_or_scope, *args, options.merge(store: false)
  end

  def respond_with(resource, _opts={})
    @user = resource
    render 'users/show'
  end

  def respond_to_on_destroy
    head :no_content
  end
end
