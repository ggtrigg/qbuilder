FactoryBot.define do
  factory :questionnaire do
    title { Faker::String.random length: 15 }
    user
  end
end
