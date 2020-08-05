FactoryBot.define do
  factory :ingredient do
    association :recipe
    food { 'nutritional yeast' }
    amount { '1' }
    preparation { 'chopped' }
    optional { false }
    unit { 'cup' }
    amount_as_float { nil }
  end
end
