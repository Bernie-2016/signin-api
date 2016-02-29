FactoryGirl.define do
  factory :signup do
    event

    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number }
    zip { Faker::Address.zip_code[0...5] }
    can_text 'Yes'
  end
end
