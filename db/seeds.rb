USER_EMAIL = 'j@j.j'

CASHEW_SAUCE_PASTA = "Wholewheat pasta with cashew-cheese sauce".freeze
TOMATO_OLIVE_BASIL_PIZZA = "Tomato, olive and basil wholewheat pizza".freeze

if Rails.env.development?
  puts "Hiring chef..."
  user = User.find_by(email: USER_EMAIL) || User.create!(
    email: USER_EMAIL,
    username: 'jro',
    password: 'jjjjjjjj',
    admin: true,
    dark_mode: true,
    twitter_handle: 'plantasusual',
    instagram_handle: 'plantasusual',
    website_url: 'https://www.plantasusual.com/'
  )
  puts "Chef hired"

  puts "Cleaning pasta plates..."
  Recipe.where(name: CASHEW_SAUCE_PASTA).destroy_all
  puts "Pasta plates clean"

  puts "Making fresh pasta..."
  puts "Writing recipe..."
  pasta = Recipe.create!(
    user: user,
    name: CASHEW_SAUCE_PASTA,
    process: "Pre-soak the cashews at room temperature for 4-8 hours.\r\n\r\nIn a skillet, fry the onion and the garlic with the olive oil and a little salt and pepper over a medium heat for about ten minutes, until starting to soften. While they're cooking bring a pot of water to the boil.\r\n\r\nNow place the onion and garlic in a blender with the cashews, cumin, chilli powder, nutritional yeast, corn starch and vegetable stock. Blend until smooth and creamy.\r\n\r\nAdd back to the skillet and cook on a low heat to thicken; about ten minutes. At the same time add the wholewheat pasta to the boiling water and cook according to the package instructions.\r\n\r\nWhen ready, drain the pasta and mix in the creamy sauce. Add the oregano and serve, optionally seasoning with salt and pepper.\r\n"
  )
  puts "Recipe written"

  puts "Preparing ingredients..."
  Ingredient.create!(
    recipe: pasta,
    food: "cashews",
    amount: '1',
    unit: Ingredient.inhuman_units[:cup],
    preparation: "soaked for 6-8 hours"
  )

  Ingredient.create!(
    recipe: pasta,
    food: "onion",
    amount: '1',
    preparation: "chopped"
  )

  Ingredient.create!(
    recipe: pasta,
    food: "garlic",
    amount: '4',
    unit: Ingredient.inhuman_units[:clove],
    preparation: "crushed"
  )

  Ingredient.create!(
    recipe: pasta,
    food: "olive oil",
    amount: '1',
    unit: Ingredient.inhuman_units[:dash]
  )

  Ingredient.create!(
    recipe: pasta,
    food: "nutritional yeast",
    amount: '2',
    unit: Ingredient.inhuman_units[:tablespoon]
  )

  Ingredient.create!(
    recipe: pasta,
    food: "corn starch",
    amount: '1',
    unit: Ingredient.inhuman_units[:tablespoon]
  )

  Ingredient.create!(
    recipe: pasta,
    food: "vegetable stock",
    amount: '1',
    unit: Ingredient.inhuman_units[:cup]
  )

  Ingredient.create!(
    recipe: pasta,
    food: "cumin",
    amount: '1',
    unit: Ingredient.inhuman_units[:teaspoon]
  )

  Ingredient.create!(
    recipe: pasta,
    food: "ground chilli",
    amount: '0.5',
    unit: Ingredient.inhuman_units[:teaspoon],
    optional: true
  )

  Ingredient.create!(
    recipe: pasta,
    food: "wholewheat pasta",
    amount: '250',
    unit: Ingredient.inhuman_units[:gram]
  )

  Ingredient.create!(
    recipe: pasta,
    food: "oregano",
    optional: true
  )

  Ingredient.create!(
    recipe: pasta,
    food: "black pepper"
  )

  Ingredient.create!(
    recipe: pasta,
    food: "sea salt"
  )
  puts "Ingredients prepped"

  puts "Taking photo..."
  File.open('app/assets/images/seed_photos/cashew_sauce_pasta.jpg') { |f| pasta.photo = f }
  pasta.save
  puts "Photo snapped"

  puts "Pasta served"


  puts "Cleaning pizza dishes..."
  Recipe.where(name: TOMATO_OLIVE_BASIL_PIZZA).destroy_all
  puts "Pizza dishes clean"

  puts "Making pizza..."
  puts "Writing recipe..."
  pizza = Recipe.create!(
    user: user,
    name: TOMATO_OLIVE_BASIL_PIZZA,
    process: "To make the dough, place the flour, sea salt and nutritional yeast into a food processor and pulse to mix. In a mug or a measuring jug, whisk together the sugar, olive oil and yeast with the hot water (almost too hot to touch), and allow the yeast to proof for a couple of minutes. With the food processor running, slowly pour in this mixture and keep it running until a firm dough forms.\r\n\r\nDump the dough onto a floured surface and knead it a few times. Then divide it into two, and with a rolling pin or the side of a glass, roll the dough until at its desired thickness. Circular pizza bases should each be about 12-inches in diameter. Transfer each one onto baking tray (either a non-stick baking tray, a lightly greased baking tray, or one lined with cooking paper).\r\n\r\nFirstly add the chopped tomatoes, followed by the halved cherry tomatoes, then the green olives, then the garlic (and any other ingredients you desire) and place into an oven preheated to 250 celsius.\r\n\r\nBake until lightly browned (roughly 12 - 15 mins), optionally adding the vegan cheese for the last couple of minutes of cooking. Optionally sprinkle on the oregano, black pepper, sea salt, and if adding basil leaves, wait for the pizzas to cool for a couple of minutes. Serve immediately."
  )
  puts "Recipe written"

  puts "Preparing ingredients..."
  Ingredient.create!(
    recipe: pizza,
    food: "garlic",
    amount: '4',
    unit: Ingredient.inhuman_units[:clove],
    preparation: "crushed"
  )

  Ingredient.create!(
    recipe: pizza,
    food: "olive oil",
    amount: '1',
    unit: Ingredient.inhuman_units[:tablespoon]
  )

  Ingredient.create!(
    recipe: pizza,
    food: "nutritional yeast",
    amount: '0.25',
    unit: Ingredient.inhuman_units[:cup],
    optional: true
  )

  Ingredient.create!(
    recipe: pizza,
    food: "oregano",
    optional: true
  )

  Ingredient.create!(
    recipe: pizza,
    food: "sea salt",
    amount: '1',
    unit: Ingredient.inhuman_units[:teaspoon]
  )

  Ingredient.create!(
    recipe: pizza,
    food: "hot water",
    amount: '1',
    unit: Ingredient.inhuman_units[:cup]
  )

  Ingredient.create!(
    recipe: pizza,
    food: "brown sugar",
    amount: '1',
    unit: Ingredient.inhuman_units[:tablespoon]
  )

  Ingredient.create!(
    recipe: pizza,
    food: "instant yeast",
    amount: '2.25',
    unit: Ingredient.inhuman_units[:teaspoon]
  )

  Ingredient.create!(
    recipe: pizza,
    food: "wholewheat flour",
    amount: '2.75',
    unit: Ingredient.inhuman_units[:cup]
  )

  Ingredient.create!(
    recipe: pizza,
    food: "chopped tomatoes",
    amount: '2',
    unit: Ingredient.inhuman_units[:can],
    preparation: "drained"
  )

  Ingredient.create!(
    recipe: pizza,
    food: "vegan cheese",
    amount: '100',
    unit: Ingredient.inhuman_units[:gram],
    optional: true
  )

  Ingredient.create!(
    recipe: pizza,
    food: "green olives",
    amount: '1',
    unit: Ingredient.inhuman_units[:can],
    preparation: "halved"
  )

  Ingredient.create!(
    recipe: pizza,
    food: "cherry tomatoes",
    amount: '1',
    unit: Ingredient.inhuman_units[:pack],
    preparation: "halved"
  )

  Ingredient.create!(
    recipe: pizza,
    food: "fresh basil",
    amount: 'several',
    unit: Ingredient.inhuman_units[:leaf],
    optional: true
  )
  puts "Ingredients prepped"

  puts "Taking photo..."
  File.open('app/assets/images/seed_photos/tomato_olive_and_basil_wholewheat_pizza.jpg') { |f| pizza.photo = f }
  pizza.save
  puts "Photo snapped"

  puts "Pizza served"
end

