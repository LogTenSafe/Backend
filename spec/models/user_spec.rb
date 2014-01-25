require 'spec_helper'

describe User do
  describe '#authentic?' do
    subject { FactoryGirl.create(:user, password: 'example password') }

    it { should be_authentic('example password') }
    it { should_not be_authentic('another password') }
  end

  describe '.authenticate' do
    let(:user) { FactoryGirl.create(:user, password: 'some password') }
    subject { User.authenticate(login, password) }

    context "with correct credentials" do
      let(:login) { user.login }
      let(:password) { 'some password' }

      it { should eql(user) }
    end

    context "with incorrect credentials" do
      let(:login) { user.login }
      let(:password) { 'another password' }

      it { should be_nil }
    end

    context "with an unknown login" do
      let(:login) { 'not-found' }
      let(:password) { 'some password' }

      it { should be_nil }
    end
  end

  describe 'password' do
    subject { FactoryGirl.create(:user) }

    context '[newly created]' do
      its(:crypted_password) { should_not be_nil }
    end

    it "should change when the password changes" do
      user = subject
      expect { user.update_attributes(password: 'new', password_confirmation: 'new') }.
        to change(user, :crypted_password)
    end

    context "not given to a newly-created user" do
      subject { FactoryGirl.build(:user, password: nil) }

      it { should_not be_valid }
    end

    context "existing user" do
      subject { FactoryGirl.create(:user) }
      before { subject.update_attributes attrs }

      context "login changed only" do
        let(:attrs) { { login: 'another' } }
        it { should be_valid }
      end

      context "login and password changed without confirmation" do
        let(:attrs) { { login: 'another2', password: 'another' } }
        it { should be_valid }
      end

      context "login and password changed with confirmation" do
        let(:attrs) { { login: 'another3', password: 'another', password_confirmation: 'another' } }
        it { should be_valid }
      end
    end
  end

  describe 'pepper' do
    subject { FactoryGirl.create(:user) }
    its(:pepper) { should_not be_nil }
  end
end
