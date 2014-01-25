FactoryGirl.define do
  factory :user do
    sequence(:login) { |i| "user-#{i}" }
    password 'password123'
  end
end
