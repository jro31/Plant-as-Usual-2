preparation_methods = ['soaked', 'chopped', 'drained', 'peeled', 'crushed']

FactoryBot.define do
  factory :ingredient do
    association :recipe
    food { Faker::Food.ingredient }
    amount { (1..50).to_a.sample.to_s }
    preparation { preparation_methods.sample }
    optional { Faker::Boolean.boolean }
    unit { 'cup' }
  end

  factory :ingredient_with_recipe, parent: :ingredient do
    after(:build) do |ingredient, _|
      ingredient.recipe = create(:recipe)
    end
  end
end
