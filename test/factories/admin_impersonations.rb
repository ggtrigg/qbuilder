FactoryBot.define do
  factory :admin_impersonation do
    association :admin, factory: :user, admin: true
    association :target_user, factory: :user
  end
end
