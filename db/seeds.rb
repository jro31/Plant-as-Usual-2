USER_EMAIL = 'j@j.j'

CASHEW_SAUCE_PASTA = "Wholewheat pasta with cashew-cheese sauce".freeze
TOMATO_OLIVE_BASIL_PIZZA = "Tomato, olive and basil wholewheat pizza".freeze
STOVE_TOP_MAC_N_CHEESE = "Stove-top mac 'n' cheese".freeze
OIL_FREE_FRENCH_FRIES_WITH_KETCHUP = "Oil-free French fries with ketchup".freeze
BLACK_PEPPER_STIR_FRY = "Black pepper stir-fry".freeze
PASTA_WITH_TOFU_CHEESE_SAUCE = "Pasta with tofu cheese sauce".freeze

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
    process: "Pre-soak the cashews at room temperature for 4-8 hours.\r\n\r\nIn a skillet, fry the onion and the garlic with the olive oil and a little salt and pepper over a medium heat for about ten minutes, until starting to soften. While they're cooking bring a pot of water to the boil.\r\n\r\nNow place the onion and garlic in a blender with the cashews, cumin, chilli powder, nutritional yeast, corn starch and vegetable stock. Blend until smooth and creamy.\r\n\r\nAdd back to the skillet and cook on a low heat to thicken; about ten minutes. At the same time add the wholewheat pasta to the boiling water and cook according to the package instructions.\r\n\r\nWhen ready, drain the pasta and mix in the creamy sauce. Add the oregano and serve, optionally seasoning with salt and pepper.\r\n",
    state: :approved_for_recipe_of_the_day
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
    process: "To make the dough, place the flour, sea salt and nutritional yeast into a food processor and pulse to mix. In a mug or a measuring jug, whisk together the sugar, olive oil and yeast with the hot water (almost too hot to touch), and allow the yeast to proof for a couple of minutes. With the food processor running, slowly pour in this mixture and keep it running until a firm dough forms.\r\n\r\nDump the dough onto a floured surface and knead it a few times. Then divide it into two, and with a rolling pin or the side of a glass, roll the dough until at its desired thickness. Circular pizza bases should each be about 12-inches in diameter. Transfer each one onto baking tray (either a non-stick baking tray, a lightly greased baking tray, or one lined with cooking paper).\r\n\r\nFirstly add the chopped tomatoes, followed by the halved cherry tomatoes, then the green olives, then the garlic (and any other ingredients you desire) and place into an oven preheated to 250 celsius.\r\n\r\nBake until lightly browned (roughly 12 - 15 mins), optionally adding the vegan cheese for the last couple of minutes of cooking. Optionally sprinkle on the oregano, black pepper, sea salt, and if adding basil leaves, wait for the pizzas to cool for a couple of minutes. Serve immediately.",
    state: :approved_for_recipe_of_the_day
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


  puts "Cleaning baking dishes..."
  Recipe.where(name: STOVE_TOP_MAC_N_CHEESE).destroy_all
  puts "Baking dishes clean"

  puts "Making stove-top mac 'n' cheese..."
  puts "Writing recipe..."
  mac_n_cheese = Recipe.create!(
    user: user,
    name: STOVE_TOP_MAC_N_CHEESE,
    process: "Mix the potato, carrot, onion, turmeric and garlic in a covered saucepan with 470ml water and bring to the boil. Reduce the heat to low and simmer for 20 minutes.\n\nMeanwhile, cover the cashews with water, soak them for 10 minutes, and then drain. Cook the pasta according to the package instructions.\n\nTransfer the potato mixture to a blender (you can instead do this in the pan or a large bowl if you have a hand-blender), and add the cashews, nutritional yeast, a bit of sea salt and 120ml more water. Blend until smooth and creamy.\n\nMix the pasta with as much of the sauce as desired, and top with black pepper, and optionally more sea salt or any herbs.\n\nLeftover sauce can be refrigerated and reheated on the stove as needed.",
    state: :approved_for_recipe_of_the_day
  )
  puts "Recipe written"

  puts "Preparing ingredients..."
  Ingredient.create!(
    recipe: mac_n_cheese,
    food: "potato",
    amount: '1',
    unit: Ingredient.inhuman_units[:large],
    preparation: "diced"
  )

  Ingredient.create!(
    recipe: mac_n_cheese,
    food: "carrot",
    amount: '1',
    unit: Ingredient.inhuman_units[:medium],
    preparation: "chopped"
  )

  Ingredient.create!(
    recipe: mac_n_cheese,
    food: "yellow onion",
    amount: '1',
    preparation: "chopped"
  )

  Ingredient.create!(
    recipe: mac_n_cheese,
    food: "turmeric",
    amount: '1',
    unit: Ingredient.inhuman_units[:teaspoon]
  )

  Ingredient.create!(
    recipe: mac_n_cheese,
    food: "garlic",
    amount: '3',
    unit: Ingredient.inhuman_units[:clove],
    preparation: "minced"
  )

  Ingredient.create!(
    recipe: mac_n_cheese,
    food: "cashews",
    amount: '120',
    unit: Ingredient.inhuman_units[:millilitre]
  )

  Ingredient.create!(
    recipe: mac_n_cheese,
    food: "dried wholewheat pasta",
    amount: '250',
    unit: Ingredient.inhuman_units[:gram]
  )

  Ingredient.create!(
    recipe: mac_n_cheese,
    food: "nutritional yeast",
    amount: '120',
    unit: Ingredient.inhuman_units[:millilitre]
  )

  Ingredient.create!(
    recipe: mac_n_cheese,
    food: "sea salt"
  )

  Ingredient.create!(
    recipe: mac_n_cheese,
    food: "black pepper"
  )
  puts "Ingredients prepped"

  puts "Taking photo..."
  File.open('app/assets/images/seed_photos/stove_top_mac_n_cheese.jpg') { |f| mac_n_cheese.photo = f }
  mac_n_cheese.save
  puts "Photo snapped"

  puts "Stove-top mac 'n' cheese served"


  puts "Cleaning chip baskets..."
  Recipe.where(name: OIL_FREE_FRENCH_FRIES_WITH_KETCHUP).destroy_all
  puts "Chip baskets clean"

  puts "Making oil-free French fries with ketchup..."
  puts "Writing recipe..."
  french_fries = Recipe.create!(
    user: user,
    name: OIL_FREE_FRENCH_FRIES_WITH_KETCHUP,
    process: "To make the French fries, preheat an oven to 205°C.\n\nCut the potatoes into French fry sized sticks. Optionally peel them before doing this, although I prefer to leave the skin on.\n\nPut the potato sticks onto a baking tray lined with cooking paper. Ideally you want to have just a single layer of fries, so if you have multiple baking trays, that is better. If not, stack the fries onto the baking tray leaving as much space between each one as possible.\n\nBake the fries for 15 minutes, remove them from the oven and flip them over, and bake for another 15 minutes.\n\nIn the meantime, to make the ketchup, combine all remaining ingredients in a blender, blending until smooth.\n\nServe the fries and ketchup immediately. Any leftover ketchup can be stored in the refrigerator for 1-2 weeks.",
    state: :approved_for_recipe_of_the_day
  )
  puts "Recipe written"

  puts "Preparing ingredients..."
  Ingredient.create!(
    recipe: french_fries,
    food: "potatoes",
    amount: '2',
    unit: Ingredient.inhuman_units[:large]
  )

  Ingredient.create!(
    recipe: french_fries,
    food: "tomato paste",
    amount: '170',
    unit: Ingredient.inhuman_units[:gram]
  )

  Ingredient.create!(
    recipe: french_fries,
    food: "apple",
    amount: '1'
  )

  Ingredient.create!(
    recipe: french_fries,
    food: "lemon juice",
    amount: '1',
    unit: Ingredient.inhuman_units[:tablespoon]
  )

  Ingredient.create!(
    recipe: french_fries,
    food: "garlic powder",
    amount: 'A quarter',
    unit: Ingredient.inhuman_units[:teaspoon]
  )

  Ingredient.create!(
    recipe: french_fries,
    food: "oregano",
    amount: 'A quarter',
    unit: Ingredient.inhuman_units[:teaspoon]
  )
  puts "Ingredients prepped"

  puts "Taking photo..."
  File.open('app/assets/images/seed_photos/oil_free_french_fries_with_ketchup.jpg') { |f| french_fries.photo = f }
  french_fries.save
  puts "Photo snapped"

  puts "Oil-free French fries with ketchup served"


  puts "Cleaning wok..."
  Recipe.where(name: BLACK_PEPPER_STIR_FRY).destroy_all
  puts "Wok clean"

  puts "Making black pepper stir-fry..."
  puts "Writing recipe..."
  stir_fry = Recipe.create!(
    user: user,
    name: BLACK_PEPPER_STIR_FRY,
    process: "Before cooking, make the black pepper sauce by mixing together the soy sauce, rice vinegar, brown sugar, vegetable stock, black pepper and corn starch.\n\nFor the stir-fry you can use any ingredients you've got lying around, which makes it perfect when you have some veg that you need to use up. If using a protein, such as tofu, you'll probably want to cook that separately before cooking the veg.\n\nPreheat a dash of olive oil in a wok or large frying pan over a medium-high heat, then add the garlic (or any other aromatic that you're using, such as shallots or ginger) and cook just long enough for them to give off a pungent smell.\n\nAdd the remaining ingredients and stir-fry for until tender, but still crunchy. Around 10 minutes.\n\nIf you pre-cooked a protein, add it back into the pan here.\n\nPush all the ingredients to the side of the pan, creating a well in the middle. And giving it one final stir, pour the black pepper sauce into well.\n\nWait for it to just start to bubble, before tossing it through all the other ingredients.\n\nCook for a little bit longer, or until you get bored, and serve immediately.",
    state: :approved_for_feature
  )
  puts "Recipe written"

  puts "Preparing ingredients..."
  Ingredient.create!(
    recipe: stir_fry,
    food: "garlic"
  )

  Ingredient.create!(
    recipe: stir_fry,
    food: "baby corn"
  )

  Ingredient.create!(
    recipe: stir_fry,
    food: "carrot"
  )

  Ingredient.create!(
    recipe: stir_fry,
    food: "snow peas"
  )

  Ingredient.create!(
    recipe: stir_fry,
    food: "cherry tomatoes"
  )

  Ingredient.create!(
    recipe: stir_fry,
    food: "broccoli"
  )

  Ingredient.create!(
    recipe: stir_fry,
    food: "yellow pepper"
  )

  Ingredient.create!(
    recipe: stir_fry,
    food: "bok choy"
  )

  Ingredient.create!(
    recipe: stir_fry,
    food: "raisins"
  )

  Ingredient.create!(
    recipe: stir_fry,
    food: "cashews"
  )

  Ingredient.create!(
    recipe: stir_fry,
    food: "sea salt"
  )

  Ingredient.create!(
    recipe: stir_fry,
    food: "olive oil"
  )

  Ingredient.create!(
    recipe: stir_fry,
    food: "soy sauce",
    amount: '3',
    unit: Ingredient.inhuman_units[:tablespoon]
  )

  Ingredient.create!(
    recipe: stir_fry,
    food: "rice vinegar",
    amount: '2',
    unit: Ingredient.inhuman_units[:teaspoon]
  )

  Ingredient.create!(
    recipe: stir_fry,
    food: "brown sugar",
    amount: '1',
    unit: Ingredient.inhuman_units[:teaspoon]
  )

  Ingredient.create!(
    recipe: stir_fry,
    food: "vegetable stock",
    amount: '120',
    unit: Ingredient.inhuman_units[:millilitre]
  )

  Ingredient.create!(
    recipe: stir_fry,
    food: "black pepper",
    amount: '1.5',
    unit: Ingredient.inhuman_units[:teaspoon]
  )

  Ingredient.create!(
    recipe: stir_fry,
    food: "corn starch",
    amount: '1',
    unit: Ingredient.inhuman_units[:tablespoon]
  )
  puts "Ingredients prepped"

  puts "Taking photo..."
  File.open('app/assets/images/seed_photos/black_pepper_stir_fry.jpg') { |f| stir_fry.photo = f }
  stir_fry.save
  puts "Photo snapped"

  puts "Black pepper stir-fry served"


  puts "Cleaning pasta bowls..."
  Recipe.where(name: PASTA_WITH_TOFU_CHEESE_SAUCE).destroy_all
  puts "Pasta bowls clean"

  puts "Making pasta with tofu cheese sauce..."
  puts "Writing recipe..."
  tofu_sauce_pasta = Recipe.create!(
    user: user,
    name: PASTA_WITH_TOFU_CHEESE_SAUCE,
    process: "Cook the tagliatelle according to the package instructions.\n\nMeanwhile, add all remaining ingredients to a blender and blend until smooth.\n\nWarm the sauce in a pan gently on the stove, stirring frequently. Then mix with the pasta and serve.",
    state: :approved_for_recipe_of_the_day
  )
  puts "Recipe written"

  puts "Preparing ingredients..."
  Ingredient.create!(
    recipe: tofu_sauce_pasta,
    food: "silken tofu",
    amount: '340',
    unit: Ingredient.inhuman_units[:gram]
  )

  Ingredient.create!(
    recipe: tofu_sauce_pasta,
    food: "nutritional yeast",
    amount: '120',
    unit: Ingredient.inhuman_units[:millilitre]
  )

  Ingredient.create!(
    recipe: tofu_sauce_pasta,
    food: "onion powder",
    amount: '1.5',
    unit: Ingredient.inhuman_units[:teaspoon]
  )

  Ingredient.create!(
    recipe: tofu_sauce_pasta,
    food: "garlic powder",
    amount: 'Half',
    unit: Ingredient.inhuman_units[:teaspoon]
  )

  Ingredient.create!(
    recipe: tofu_sauce_pasta,
    food: "smoked paprika",
    amount: 'A quarter',
    unit: Ingredient.inhuman_units[:teaspoon]
  )

  Ingredient.create!(
    recipe: tofu_sauce_pasta,
    food: "dijon mustard",
    amount: '2',
    unit: Ingredient.inhuman_units[:teaspoon]
  )

  Ingredient.create!(
    recipe: tofu_sauce_pasta,
    food: "white wine vinegar",
    amount: '1',
    unit: Ingredient.inhuman_units[:teaspoon]
  )

  Ingredient.create!(
    recipe: tofu_sauce_pasta,
    food: "sea salt"
  )

  Ingredient.create!(
    recipe: tofu_sauce_pasta,
    food: "plant-based milk",
    amount: '120',
    unit: Ingredient.inhuman_units[:millilitre]
  )

  Ingredient.create!(
    recipe: tofu_sauce_pasta,
    food: "wholewheat tagliatelle",
    amount: '250',
    unit: Ingredient.inhuman_units[:gram]
  )
  puts "Ingredients prepped"

  puts "Taking photo..."
  File.open('app/assets/images/seed_photos/pasta_with_tofu_cheese_sauce.jpg') { |f| tofu_sauce_pasta.photo = f }
  tofu_sauce_pasta.save
  puts "Photo snapped"

  puts "Pasta with tofu cheese sauce served"



  puts "Setting featured recipes..."
  Recipe.update_highlighted_recipes
  puts "Featured recipes set"
end

