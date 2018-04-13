require 'securerandom'

FactoryBot.define do
  factory :backup do
    association :user
    logbook { Rails.root.join('spec', 'fixtures', 'backup.sql') }
    hostname 'test-host'

    after :build do |backup, evaluator|
      if evaluator.logbook
        backup.logbook.attach io: evaluator.logbook.open, filename: 'backup.sql', content_type: 'application/x-sqlite3'
      end
    end
  end
end
