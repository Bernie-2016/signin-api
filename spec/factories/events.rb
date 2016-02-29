FactoryGirl.define do
  factory :event do
    user

    name { Faker::Lorem.word }
    slug { Faker::Internet.slug }
  end
end
