FactoryBot.define do
  factory :user do
    name { "User1" }
    email { "user1@example.com" }
    provider { "google_oauth2" }
    uid { SecureRandom.uuid }
    image { "/app/assets/images/default_user_icon" }

    trait :another_user do
      name { "User2" }
      email { "user2@example.com" }
      provider { "google_oauth2" }
      uid { SecureRandom.uuid }
      image { "/app/assets/images/default_user_icon" }
    end
  end
end
