require 'rails_helper'

RSpec.describe "Backups", type: :request do
  include Devise::Test::IntegrationHelpers

  describe "GET /index" do
    let(:user) { FactoryBot.create :user }

    before :each do
      @backups = FactoryBot.create_list(:backup, 12, user: user)
      @backups.each_with_index { |b, i| b.update created_at: i.minutes.ago }

      # red herring - belongs to someone else
      FactoryBot.create :backup
      # red herring - not analyzed
      FactoryBot.create :backup, user: user, skip_analyze: true
    end

    around :each do |ex|
      previous_per_page = BackupsController.const_get :PER_PAGE
      BackupsController.const_set :PER_PAGE, 10
      ex.run
      BackupsController.const_set :PER_PAGE, previous_per_page
    end

    it "requires a log in" do
      get '/backups.json'
      expect(response.status).to eq(401)
    end

    context "[logged in]" do
      before(:each) { sign_in user }

      it "returns the user's most recent backups" do
        get '/backups.json'
        expect(response.status).to eq(200)
        expect(response.body).to match_json_expression(@backups.first(10).map do |backup|
          {
              id:           backup.id,
              hostname:     backup.hostname,
              last_flight:  backup.last_flight,
              total_hours:  backup.total_hours,
              created_at:   String,
              logbook:      {size: Integer, analyzed: true},
              download_url: String,
              destroyed:    false
          }
        end)

        expect(response.headers['X-Next-Page']).
            to eq("http://www.example.com/backups.json?before=#{CGI.escape @backups[9].created_at.xmlschema}")
      end

      it "returns the next page when given a 'before' parameter" do
        get "/backups.json?before=#{CGI.escape @backups[9].created_at.xmlschema}"
        expect(response.status).to eq(200)
        expect(response.body).to match_json_expression(@backups[10, 10].map do |backup|
          {
              id:           backup.id,
              hostname:     backup.hostname,
              last_flight:  backup.last_flight,
              total_hours:  backup.total_hours,
              created_at:   String,
              logbook:      {size: Integer, analyzed: true},
              download_url: String,
              destroyed:    false
          }
        end)

        expect(response.headers['X-Next-Page']).to be_nil
      end
    end
  end

  describe "GET /show" do
    let(:backup) { FactoryBot.create :backup }
    let(:user) { backup.user }

    it "requires a log in" do
      get "/backups/#{backup.to_param}.json"
      expect(response.status).to eq(401)
    end

    context "[logged in]" do
      before(:each) { sign_in user }

      it "returns JSON information about a backup" do
        get "/backups/#{backup.to_param}.json"
        expect(response.status).to eq(200)
        expect(response.body).
            to match_json_expression(
                   id:           backup.id,
                   hostname:     backup.hostname,
                   last_flight:  backup.last_flight,
                   total_hours:  backup.total_hours,
                   created_at:   String,
                   logbook:      {size: Integer, analyzed: true},
                   download_url: String,
                   destroyed:    false
               )
      end

      it "handles an unknown backup" do
        get '/backups/hi.json'
        expect(response.status).to eq(404)
      end

      it "does not allow access to someone else's backup" do
        get "/backups/#{FactoryBot.create(:backup).to_param}.json"
        expect(response.status).to eq(404)
      end
    end
  end

  describe "POST /create" do
    let(:user) { FactoryBot.create :user }
    let :backup_params do
      file = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'LogTenCoreDataStore.sql').to_s,
                                 'application/sql',
                                 :binary)
      {
          hostname: 'host',
          logbook:  file
      }
    end

    it "requires a log in" do
      post "/backups.json", params: {backup: backup_params}
      expect(response.status).to eq(401)
    end

    context "[logged in]" do
      before(:each) { sign_in user }

      it "adds a new backup" do
        post "/backups.json", params: {backup: backup_params}

        expect(response.status).to eq(200)
        backup = Backup.find(response.parsed_body['id'])
        expect(backup.hostname).to eq('host')
        expect(backup.user_id).to eq(user.id)
      end

      it "handles errors" do
        post "/backups.json", params: {backup: backup_params.merge(logbook: nil)}
        expect(response.status).to eq(422)
        expect(response.body).to match_json_expression(
                                     errors: {logbook: ["can't be blank"]}
                                 )
      end
    end
  end

  describe "DELETE /destroy" do
    let(:backup) { FactoryBot.create :backup }
    let(:user) { backup.user }

    it "requires a log in" do
      delete "/backups/#{backup.to_param}.json"
      expect(response.status).to eq(401)
      expect { backup.reload }.not_to raise_error
    end

    context "[logged in]" do
      before(:each) { sign_in user }

      it "deletes a backup" do
        delete "/backups/#{backup.to_param}.json"
        expect(response.status).to eq(200)
        expect(response.body).to match_json_expression(
                                     id:           backup.id,
                                     hostname:     backup.hostname,
                                     last_flight:  backup.last_flight,
                                     total_hours:  backup.total_hours,
                                     created_at:   String,
                                     logbook:      {size: Integer, analyzed: true},
                                     download_url: String,
                                     destroyed:    true
                                 )
        expect { backup.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "handles an unknown backup" do
        delete '/backups/oops.json'
        expect(response.status).to eq(404)
      end

      it "doesn't delete a backup belonging to a different user" do
        backup = FactoryBot.create(:backup)

        delete "/backups/#{backup.to_param}.json"

        expect(response.status).to eq(404)
        expect { backup.reload }.not_to raise_error
      end
    end
  end
end
