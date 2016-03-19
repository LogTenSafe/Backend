require 'rails_helper'

RSpec.describe Backup, type: :model do
  describe 'last_flight_date' do
    subject { FactoryGirl.create(:backup).last_flight_date }

    it { is_expected.to eql(Date.civil(2014, 1, 15)) }
  end

  describe 'last_flight' do
    subject { FactoryGirl.create(:backup).last_flight }

    it { is_expected.to eql({
                      'origin'      => 'LVK',
                      'destination' => 'SQL',
                      'duration'    => 0.6
                    }) }
  end

  describe 'total_hours' do
    subject { FactoryGirl.create(:backup).total_hours.to_f }

    it { is_expected.to eql(409.9) }
  end

  context '[empty logbook]' do
    describe 'last_flight_date' do
      subject { FactoryGirl.create(:backup, logbook: File.open(Rails.root.join('spec', 'fixtures', 'empty.sql'))).last_flight_date }

      it { is_expected.to be_nil }
    end

    describe 'last_flight' do
      subject { FactoryGirl.create(:backup, logbook: File.open(Rails.root.join('spec', 'fixtures', 'empty.sql'))).last_flight }

      it { is_expected.to eql({}) }
    end

    describe 'total_hours' do
      subject { FactoryGirl.create(:backup, logbook: File.open(Rails.root.join('spec', 'fixtures', 'empty.sql'))).total_hours.to_f }

      it { is_expected.to be_zero }
    end
  end
end
