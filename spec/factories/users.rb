FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    provider { "google_oauth2" }
    uid { SecureRandom.uuid }
    image { "/app/assets/images/default_user_icon" }
  end
end
