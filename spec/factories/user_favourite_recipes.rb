FactoryBot.define do
  factory :user_favourite_recipe do
    association :user
    association :recipe
  end
end
