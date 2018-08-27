FactoryBot.define do
  factory :user do
    sequence(:login) { |i| "user-#{i}" }
    password { FFaker::Internet.password }
  end
end
