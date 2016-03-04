FactoryGirl.define do
  factory :event do
    user

    name { Faker::Lorem.word }
    slug { Faker::Internet.slug }
    date { Time.zone.today }
  end
end
