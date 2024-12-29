FactoryBot.define do
  factory :question do
    blurb { Faker::String.random length: 15 }
    answer_type { Question.answer_types.keys.sample }
    questionnaire
  end
end