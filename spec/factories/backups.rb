require 'securerandom'

FactoryBot.define do
  factory :backup do
    association :user
    logbook { File.open Rails.root.join('spec', 'fixtures', 'backup.sql') }
    logbook_fingerprint { SecureRandom.hex(64) } # need to override the fingerprint to circumvent uniqueness checks
    hostname 'test-host'
  end
end
