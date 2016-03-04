FactoryGirl.define do
  factory :event do
    user

    name { Faker::Lorem.word }
    slug { Faker::Internet.slug }
    date { Date.today }
  end
end
