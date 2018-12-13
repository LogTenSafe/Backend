require 'securerandom'

FactoryBot.define do
  factory :backup do
    association :user
    logbook { Rails.root.join('spec', 'fixtures', 'backup.sql') }
    hostname { FFaker::Internet.domain_name }

    after :build do |backup, evaluator|
      backup.logbook.attach(io: evaluator.logbook.open, filename: 'backup.sql', content_type: 'application/x-sqlite3') if evaluator.logbook
    end
  end
end
