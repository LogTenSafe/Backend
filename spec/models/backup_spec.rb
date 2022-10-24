# frozen_string_literal: true

require "rails_helper"

RSpec.describe Backup do
  describe "#most_recent?" do
    before :each do
      @user    = create(:user)
      @backups = create_list(:backup, 3, user: @user)
      @backups.each_with_index { |b, i| b.update created_at: i.minutes.ago }
    end

    it "returns true given the most recent backup for a user" do
      expect(@backups.first).to be_most_recent
    end

    it "returns false given another backup" do
      expect(@backups[1]).not_to be_most_recent
      expect(@backups[2]).not_to be_most_recent
    end
  end

  {
      total_hours: 818.3,
      last_flight: {
          "date"        => "2020-05-29",
          "destination" => "SQL",
          "duration"    => 2.4,
          "origin"      => "SQL"
      }
  }.each do |property, expected_value|
    describe property do
      let(:backup_with_logbook) { create :backup }
      let(:backup_without_logbook) { build :backup, logbook: nil }
      let(:backup_without_analyzed_logbook) { build :backup, skip_analyze: true }

      it "passes the call through to the attached metadata" do
        expect(backup_with_logbook.send(property)).to eq(expected_value)
      end

      it "returns nil if there is no attached logbook" do
        expect(backup_without_logbook.send(property)).to be_nil
      end

      it "returns nil if the attached logbook has not been analyzed" do
        expect(backup_without_analyzed_logbook.send(property)).to be_nil
      end
    end
  end

  it "broadcasts changes to the user's channel" do
    backup = create(:backup)
    expect { backup.update hostname: "hello" }.
        to have_broadcasted_to(backup.user).from_channel(BackupsChannel)
  end
end
