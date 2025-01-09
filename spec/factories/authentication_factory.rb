FactoryBot.define do
  factory :authentication do
    association :user
    provider { "google" }
    uid { "12345678" }
  end
end
