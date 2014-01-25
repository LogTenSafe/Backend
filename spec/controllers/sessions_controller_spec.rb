require 'spec_helper'

describe SessionsController do
  describe '#create' do
    before(:all) { @user = FactoryGirl.create(:user, password: 'hello world') }

    context '[valid credentials]' do
      it "should log the user in and redirect to the next URL if given" do
        post :create, login: @user.login, password: 'hello world', next: '/foo/bar'
        expect(response).to redirect_to('/foo/bar')
        expect(session[:user_id]).to eql(@user.id)
      end

      it "should log the user in and redirect to the home otherwise" do
        post :create, login: @user.login, password: 'hello world'
        expect(response).to redirect_to('/')
        expect(session[:user_id]).to eql(@user.id)
      end
    end

    context '[invalid credentials]' do
      it "should re-render the form and not log the user in" do
        post :create, login: @user.login, password: 'bad'
        expect(response).to render_template('new')
        expect(session[:user_id]).to be_nil
      end
    end
  end

  describe '#destroy' do
    before(:each) { login_as(@user = FactoryGirl.create(:user)) }
    it "should log the user out and go to the root URL" do
      delete :destroy
      expect(response).to redirect_to('/')
      expect(session[:user_id]).to be_nil
    end
  end
end
