require 'rails_helper'

RSpec.describe BackupsController, type: :controller do
  describe '#index' do
    before :all do
      @user    = FactoryBot.create(:user)
      @backups = FactoryBot.create_list(:backup, 15, user: @user).sort_by(&:created_at).reverse
      # @backups.each { |b| b.logbook.analyze }
    end

    before(:each) { login_as @user }

    it "should return the list of backups" do
      get :index
      expect(assigns(:backups)).to match_array(@backups)
    end
  end

  describe '#show' do
    render_views

    before :each do
      @backup = FactoryBot.create(:backup)
      api_login_as @backup.user, 'password123'
    end

    it "should send a gzipped copy of the backup" do
      get :show, params: {id: @backup.to_param, format: 'gz'}
      skip "No way to test this without running a web server"
      expect(response.status).to eql(200)
    end
  end
end
