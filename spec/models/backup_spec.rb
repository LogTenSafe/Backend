require 'spec_helper'

describe Backup do
  describe 'last_flight_date' do
    subject { FactoryGirl.create(:backup).last_flight_date }

    it { should eql(Date.civil(2014, 1, 15)) }
  end

  describe 'last_flight' do
    subject { FactoryGirl.create(:backup).last_flight }

    it { should eql({
                      'origin'      => 'LVK',
                      'destination' => 'SQL',
                      'duration'    => 0.6
                    }) }
  end

  describe 'total_hours' do
    subject { FactoryGirl.create(:backup).total_hours.to_f }

    it { should eql(409.9) }
  end
end
