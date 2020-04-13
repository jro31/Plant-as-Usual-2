# YOU NEED TO UPDATE THIS TO HAVE UNIT AS COLUMN TYPE STRING ON INGREDIENT

CASHEW_SAUCE_PASTA = "Wholewheat pasta with cashew-cheese sauce".freeze
TOMATO_OLIVE_BASIL_PIZZA = "Tomato, olive and basil wholewheat pizza".freeze

puts "Generating units..."
units = ['gram', 'millilitre', 'pinch', 'splash', 'teaspoon', 'tablespoon', 'cup', 'dash', 'litre', 'kilogram', 'piece', 'inch', 'centimetre', 'can', 'pack', 'clove', 'whole', 'large', 'medium', 'small', 'leaf', 'pound', 'ounce', 'pint', 'fluid ounce', 'quart', 'gallon']
units.each do |u|
  unless Unit.where(name: u.downcase).exists?
    Unit.create!(name: u.downcase)
  end
end

if Recipe.where(name: CASHEW_SAUCE_PASTA).exists?
  puts "Pasta already cooked"
else
  puts "Making pasta..."
  puts "Writing recipe..."
  pasta = Recipe.create!(
    user: User.find_by(email: 'jethrowilliams@outlook.com'),
    name: CASHEW_SAUCE_PASTA,
    process: "Pre-soak the cashews at room temperature for 4-8 hours.\r\n\r\nIn a skillet, fry the onion and the garlic with the olive oil and a little salt and pepper over a medium heat for about ten minutes, until starting to soften. While they're cooking bring a pot of water to the boil.\r\n\r\nNow place the onion and garlic in a blender with the cashews, cumin, chilli powder, nutritional yeast, corn starch and vegetable stock. Blend until smooth and creamy.\r\n\r\nAdd back to the skillet and cook on a low heat to thicken; about ten minutes. At the same time add the wholewheat pasta to the boiling water and cook according to the package instructions.\r\n\r\nWhen ready, drain the pasta and mix in the creamy sauce. Add the oregano and serve, optionally seasoning with salt and pepper.\r\n",
    photo: "f8cg3fdfjo00zytfholq",
    servings: 2,
    cooking_time_minutes: 40
  )
  puts "Recipe finished"

  puts "Preparing ingredients..."
  Ingredient.create!(
    recipe: pasta,
    name: "cashews",
    amount: 1.0,
    unit: Unit.find_by(name: 'cup'),
    preparation: "soaked for 6-8 hours"
  )

  Ingredient.create!(
    recipe: pasta,
    name: "onion",
    amount: 1.0,
    preparation: "chopped"
  )

  Ingredient.create!(
    recipe: pasta,
    name: "garlic",
    amount: 4.0,
    unit: Unit.find_by(name: 'clove'),
    preparation: "crushed"
  )

  Ingredient.create!(
    recipe: pasta,
    name: "olive oil",
    amount: 1.0,
    unit: Unit.find_by(name: 'dash')
  )

  Ingredient.create!(
    recipe: pasta,
    name: "nutritional yeast",
    amount: 2.0,
    unit: Unit.find_by(name: 'tablespoon')
  )

  Ingredient.create!(
    recipe: pasta,
    name: "corn starch",
    amount: 1.0,
    unit: Unit.find_by(name: 'tablespoon')
  )

  Ingredient.create!(
    recipe: pasta,
    name: "vegetable stock",
    amount: 1.0,
    unit: Unit.find_by(name: 'cup')
  )

  Ingredient.create!(
    recipe: pasta,
    name: "cumin",
    amount: 1.0,
    unit: Unit.find_by(name: 'teaspoon')
  )

  Ingredient.create!(
    recipe: pasta,
    name: "ground chilli",
    amount: 0.5,
    unit: Unit.find_by(name: 'teaspoon'),
    optional: true
  )

  Ingredient.create!(
    recipe: pasta,
    name: "wholewheat pasta",
    amount: 250.0,
    unit: Unit.find_by(name: 'gram')
  )

  Ingredient.create!(
    recipe: pasta,
    name: "oregano",
    optional: true
  )

  Ingredient.create!(
    recipe: pasta,
    name: "black pepper"
  )

  Ingredient.create!(
    recipe: pasta,
    name: "sea salt"
  )

  puts "Ingredients prepped"
  puts "Pasta served"
end

if Recipe.where(name: TOMATO_OLIVE_BASIL_PIZZA).exists?
  puts "Pizza already cooked"
else
  puts "Making pizza..."
  puts "Writing recipe..."
  pizza = Recipe.create!(
    user: User.find_by(email: 'jethrowilliams@outlook.com'),
    name: TOMATO_OLIVE_BASIL_PIZZA,
    process: "To make the dough, place the flour, sea salt and nutritional yeast into a food processor and pulse to mix. In a mug or a measuring jug, whisk together the sugar, olive oil and yeast with the hot water (almost too hot to touch), and allow the yeast to proof for a couple of minutes. With the food processor running, slowly pour in this mixture and keep it running until a firm dough forms.\r\n\r\nDump the dough onto a floured surface and knead it a few times. Then divide it into two, and with a rolling pin or the side of a glass, roll the dough until at its desired thickness. Circular pizza bases should each be about 12-inches in diameter. Transfer each one onto baking tray (either a non-stick baking tray, a lightly greased baking tray, or one lined with cooking paper).\r\n\r\nFirstly add the chopped tomatoes, followed by the halved cherry tomatoes, then the green olives, then the garlic (and any other ingredients you desire) and place into an oven preheated to 250 celsius.\r\n\r\nBake until lightly browned (roughly 12 - 15 mins), optionally adding the vegan cheese for the last couple of minutes of cooking. Optionally sprinkle on the oregano, black pepper, sea salt, and if adding basil leaves, wait for the pizzas to cool for a couple of minutes. Serve immediately.",
    photo: "hbj8rgrptlg1gqzaudiz",
    servings: 2,
    cooking_time_minutes: 45
  )
  puts "Recipe finished"

  puts "Preparing ingredients..."
  Ingredient.create!(
    recipe: pizza,
    name: "garlic",
    amount: 4.0,
    unit: Unit.find_by(name: 'clove'),
    preparation: "crushed"
  )

  Ingredient.create!(
    recipe: pizza,
    name: "olive oil",
    amount: 1.0,
    unit: Unit.find_by(name: 'tablespoon')
  )

  Ingredient.create!(
    recipe: pizza,
    name: "nutritional yeast",
    amount: 0.25,
    unit: Unit.find_by(name: 'cup'),
    optional: true
  )

  Ingredient.create!(
    recipe: pizza,
    name: "oregano",
    optional: true
  )

  Ingredient.create!(
    recipe: pizza,
    name: "sea salt",
    amount: 1.0,
    unit: Unit.find_by(name: 'teaspoon')
  )

  Ingredient.create!(
    recipe: pizza,
    name: "hot water",
    amount: 1.0,
    unit: Unit.find_by(name: 'cup')
  )

  Ingredient.create!(
    recipe: pizza,
    name: "brown sugar",
    amount: 1.0,
    unit: Unit.find_by(name: 'tablespoon')
  )

  Ingredient.create!(
    recipe: pizza,
    name: "instant yeast",
    amount: 2.25,
    unit: Unit.find_by(name: 'teaspoon')
  )

  Ingredient.create!(
    recipe: pizza,
    name: "wholewheat flour",
    amount: 2.75,
    unit: Unit.find_by(name: 'cup')
  )

  Ingredient.create!(
    recipe: pizza,
    name: "chopped tomatoes",
    amount: 2.0,
    unit: Unit.find_by(name: 'can'),
    preparation: "drained"
  )

  Ingredient.create!(
    recipe: pizza,
    name: "vegan cheese",
    amount: 100.0,
    unit: Unit.find_by(name: 'gram'),
    optional: true
  )

  Ingredient.create!(
    recipe: pizza,
    name: "green olives",
    amount: 1.0,
    unit: Unit.find_by(name: 'can'),
    preparation: "halved"
  )

  Ingredient.create!(
    recipe: pizza,
    name: "cherry tomatoes",
    amount: 1.0,
    unit: Unit.find_by(name: 'pack'),
    preparation: "halved"
  )

  Ingredient.create!(
    recipe: pizza,
    name: "fresh basil",
    amount_description: "several",
    unit: Unit.find_by(name: 'leaf'),
    optional: true
  )

  puts "Ingredients prepped"
  puts "Pizza served"
end

