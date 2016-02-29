FactoryGirl.define do
  factory :user do
    role :user
    email { Faker::Internet.email }

    trait :admin do
      role :admin
    end
  end
end
