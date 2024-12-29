FactoryBot.define do
  factory :response do
    name { Faker::Name.name }
    address { Faker::Address.street_address }
    phone { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email }
    age { Faker::Number.between(from: 18, to: 65) }
    sex { Response.sexes.keys.sample }
    questionnaire
  end
end