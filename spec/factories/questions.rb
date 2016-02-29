FactoryGirl.define do
  factory :question do
    event
    title { Faker::Lorem.word }
    type 'text'
  end
end
