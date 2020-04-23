FactoryBot.define do
  factory :user do
    sequence(:email) { |i| "#{i}-" + FFaker::Internet.email }
    password { FFaker::Internet.password }
  end
end
