require 'spec_helper'

describe AccountController do
  before(:each) { login_as(@user = FactoryGirl.create(:user)) }

  describe '#destroy' do
    it "should log out and delete the current user" do
      delete :destroy
      expect { @user.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_url)
    end
  end
end

