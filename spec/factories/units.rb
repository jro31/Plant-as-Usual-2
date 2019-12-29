units = ['gram', 'millilitre', 'pinch', 'splash', 'teaspoon', 'tablespoon', 'cup', 'dash', 'litre', 'kilogram', 'piece', 'inch', 'centimetre', 'can', 'pack', 'clove', 'whole', 'large', 'medium', 'small', 'leaf', 'pound', 'ounce', 'pint', 'fluid ounce', 'quart', 'gallon']

FactoryBot.define do
  factory :unit do
    name { units.sample }
  end
end
