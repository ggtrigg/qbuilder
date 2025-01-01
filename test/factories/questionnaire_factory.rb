FactoryBot.define do
  factory :questionnaire do
    title { Faker::String.random length: 15 }
    description { Faker::Lorem.sentence }
    user
  end
end
