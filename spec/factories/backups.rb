# frozen_string_literal: true

FactoryBot.define do
  factory :backup do
    transient do
      logbook do
        {
            io:       File.new(Rails.root.join("spec", "fixtures", "LogTenCoreDataStore.sql").to_s),
            filename: "LogTenCoreDataStore.sql"
        }
      end
      skip_analyze { false }
    end

    association :user

    hostname { FFaker::Internet.domain_word }

    after :build do |backup, evaluator|
      backup.logbook.attach(**evaluator.logbook) if evaluator.logbook
    end

    after :create do |backup, evaluator|
      unless evaluator.skip_analyze
        backup.logbook&.blob&.analyze
      end
    end
  end
end
