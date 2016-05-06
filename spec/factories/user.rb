FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password 'password'
    password_confirmation 'password'

    trait :confirmed do
      confirmed_at Time.current
    end
  end
end
