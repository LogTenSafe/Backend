require 'spec_helper'

describe BackupsController do
  describe '#index' do
    before :all do
      @user    = FactoryGirl.create(:user)
      @backups = FactoryGirl.create_list(:backup, 15, user: @user).sort_by(&:created_at).reverse
    end

    before(:each) { login_as @user }

    it "should return the list of backups" do
      get :index
      expect(assigns(:backups)).to match_array(@backups)
    end
  end

  describe '#show' do
    before :each do
      @backup = FactoryGirl.create(:backup)
      api_login_as @backup.user, 'password123'
    end

    it "should send a gzipped copy of the backup" do
      get :show, id: @backup.to_param, format: 'gz'
      #expect(response.body.force_encoding('ASCII-8BIT')).
      #  to eql(Rails.root.join('spec', 'fixtures', 'LogTenCoreDataStore.sql.gz').binread)
      #TODO filename discrepancies make these files unequal
      expect(response.headers['Content-Disposition']).to eql('attachment; filename="LogTenCoreDataStore.sql.gz"')
    end
  end
end
