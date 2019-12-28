FactoryBot.define do
  factory :recipe do
    association :user
    name { "Waddup" }
    process { "Some method" }
    cooking_time_minutes { 15 }
  end
end
