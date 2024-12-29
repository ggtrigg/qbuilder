FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }
    admin { false }
    confirmed_at { Time.zone.now - 1.hour }
    confirmation_sent_at { Time.zone.now - 1.hour }
    confirmation_token { Faker::Internet.uuid }
  end
end
