FactoryBot.define do
  factory :recipe do
    association :user
    name { "Wholewheat pasta with cashew-cheese sauce" }
    process { "Pre-soak the cashews at room temperature for 4-8 hours.\r\n\r\nIn a skillet, fry the onion and the garlic with the olive oil and a little salt and pepper over a medium heat for about ten minutes, until starting to soften. While they're cooking bring a pot of water to the boil.\r\n\r\nNow place the onion and garlic in a blender with the cashews, cumin, chilli powder, nutritional yeast, corn starch and vegetable stock. Blend until smooth and creamy.\r\n\r\nAdd back to the skillet and cook on a low heat to thicken; about ten minutes. At the same time add the wholewheat pasta to the boiling water and cook according to the package instructions.\r\n\r\nWhen ready, drain the pasta and mix in the creamy sauce. Add the oregano and serve, optionally seasoning with salt and pepper.\r\n" }
    photo { "https://res.cloudinary.com/dftybtoej/image/upload/v1546872150/lf6ogajqh4gd240s4eka.jpg" }
    servings { (1..10).to_a.sample }
    cooking_time_minutes { (20..120).to_a.sample }

    factory :recipe_with_ingredients do
      after(:build) do |recipe|
        10.times do
          recipe.ingredients << FactoryBot.build(:ingredient)
        end
      end
    end
  end
end
