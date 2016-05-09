FactoryGirl.define do
  factory :organisation do
    name { Faker::Company.name }

    trait :with_url do
      url { Faker::Internet.url }
    end
  end
end
