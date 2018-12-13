require 'rails_helper'

RSpec.describe Backup, type: :model do
  describe 'last_flight' do
    subject { FactoryBot.create(:backup).tap { |b| b.logbook.analyze }.last_flight }
    it {
      is_expected.to eql(
        'origin'      => 'LVK',
        'destination' => 'SQL',
        'duration'    => 0.6,
        'date'        => '2014-01-15'
      )
    }
  end

  describe 'total_hours' do
    subject { FactoryBot.create(:backup).tap { |b| b.logbook.analyze }.total_hours }
    it { is_expected.to eql(409.9) }
  end

  context '[empty logbook]' do
    describe 'last_flight' do
      subject { FactoryBot.create(:backup, logbook: Rails.root.join('spec', 'fixtures', 'empty.sql')).tap { |b| b.logbook.analyze }.last_flight }
      it { is_expected.to be_nil }
    end

    describe 'total_hours' do
      subject { FactoryBot.create(:backup, logbook: Rails.root.join('spec', 'fixtures', 'empty.sql')).tap { |b| b.logbook.analyze }.total_hours }
      it { is_expected.to be_zero }
    end
  end
end
