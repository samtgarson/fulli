FactoryGirl.define do
  factory :employee do
    name { Faker::Name.name }
    date_joined { Faker::Date.between(1.month.ago, 3.years.ago) }
    title { Faker::Name.title }
    avatar { File.new("#{Rails.root}/public/avatars/original/missing.png") }
  end
end
