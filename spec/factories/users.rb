FactoryBot.define do
  factory :user do
    name { "User1" }
    email { "user1@example.com" }
    provider { "google" }
    uid { "12345" }
  end
end
