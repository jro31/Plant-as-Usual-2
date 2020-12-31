USER_EMAIL = 'j@j.j'

CASHEW_SAUCE_PASTA = "Wholewheat pasta with cashew-cheese sauce".freeze
TOMATO_OLIVE_BASIL_PIZZA = "Tomato, olive and basil wholewheat pizza".freeze
STOVE_TOP_MAC_N_CHEESE = "Stove-top mac 'n' cheese".freeze
OIL_FREE_FRENCH_FRIES_WITH_KETCHUP = "Oil-free French fries with ketchup".freeze
BLACK_PEPPER_STIR_FRY = "Black pepper stir-fry".freeze
PASTA_WITH_TOFU_CHEESE_SAUCE = "Pasta with tofu cheese sauce".freeze
QUINOA_CURRY = "Quinoa curry".freeze
SPAGHETTI_BOLOGNESE = "Spaghetti bolognese".freeze
VEGAN_PROTEIN_SHAKE = "Vegan protein shake".freeze
SMASHED_AVOCADO_ON_WHOLEWHEAT_TOAST = "Smashed avocado on wholewheat toast".freeze
WHOLEWHEAT_PITA_BREADS = "Wholewheat pita breads".freeze
HUMMUS_TOAST = "Hummus toast".freeze
# OIL_FREE_TAHINI = "Oil-free tahini".freeze
# CREAMY_MUSHROOM_AND_SUNDRIED_TOMATO_PASTA = "Creamy mushroom and sundried tomato pasta".freeze
# TOFU_PAD_THAI = "Tofu pad Thai".freeze
# SMOOTHIE_BOWL = "Smoothie bowl".freeze

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


  puts "Cleaning quinoa bowls..."
  Recipe.where(name: QUINOA_CURRY).destroy_all
  puts "Quinoa bowls clean"

  puts "Making quinoa curry..."
  puts "Writing recipe..."
  quinoa_curry_bowl = Recipe.create!(
    user: user,
    name: QUINOA_CURRY,
    process: "Put the quinoa, onion powder, and half a teaspoon of the curry powder in a pan, add 400ml of water and stir. Bring to the boil, then reduce the heat to medium-low, and simmer covered, until all of the water has been absorbed. Stir frequently to prevent it sticking.\n\nIn the meantime, put the frozen vegetables into a large frying pan, cover, and cook on a medium-low heat until the vegetables have thawed (10-15 mins). You shouldn't need to add any water here, as there will usually be enough melting ice from the vegetables (if they've been stuck at the back of your freezer for months like mine have). If the vegetables start sticking to the pan though, add a few tablespoons of water as needed. Stir occasionally.\n\nWhen the vegetables are softened, add the garlic, ginger powder, and the remaining teaspoon of curry powder and cook about a minute longer. Remove from the heat, and stir in the tahini.\n\nStir the cooked quinoa into the vegetables and serve. Optionally top with sesame seeds.\n\nIf you can't eat it all, it stores quite well in an air-tight container in the fridge, and can either be eaten cold or reheated in the microwave.",
    state: :approved_for_feature
  )
  puts "Recipe written"

  puts "Preparing ingredients..."
  Ingredient.create!(
    recipe: quinoa_curry_bowl,
    food: "quinoa",
    amount: '200',
    unit: Ingredient.inhuman_units[:millilitre]
  )

  Ingredient.create!(
    recipe: quinoa_curry_bowl,
    food: "onion powder",
    amount: '1',
    unit: Ingredient.inhuman_units[:teaspoon]
  )

  Ingredient.create!(
    recipe: quinoa_curry_bowl,
    food: "curry powder",
    amount: '1.5',
    unit: Ingredient.inhuman_units[:teaspoon]
  )

  Ingredient.create!(
    recipe: quinoa_curry_bowl,
    food: "frozen vegetables",
    amount: '500',
    unit: Ingredient.inhuman_units[:gram]
  )

  Ingredient.create!(
    recipe: quinoa_curry_bowl,
    food: "garlic",
    amount: '4-5',
    unit: Ingredient.inhuman_units[:clove],
    preparation: "minced"
  )

  Ingredient.create!(
    recipe: quinoa_curry_bowl,
    food: "tahini",
    amount: '3',
    unit: Ingredient.inhuman_units[:tablespoon]
  )

  Ingredient.create!(
    recipe: quinoa_curry_bowl,
    food: "sesame seeds",
    optional: true
  )

  Ingredient.create!(
    recipe: quinoa_curry_bowl,
    food: "ginger powder",
    amount: '1',
    unit: Ingredient.inhuman_units[:teaspoon]
  )
  puts "Ingredients prepped"

  puts "Taking photo..."
  File.open('app/assets/images/seed_photos/quinoa_curry.jpg') { |f| quinoa_curry_bowl.photo = f }
  quinoa_curry_bowl.save
  puts "Photo snapped"

  puts "Quinoa curry served"


  puts "Cleaning bolognese jars..."
  Recipe.where(name: SPAGHETTI_BOLOGNESE).destroy_all
  puts "Bolognese jars clean"

  puts "Making spaghetti bolognese..."
  puts "Writing recipe..."
  spag_bol = Recipe.create!(
    user: user,
    name: SPAGHETTI_BOLOGNESE,
    process: "In a large mixing bowl, mash the tofu with a fork. Now blend the walnuts in a food processor until finely chopped, and add them to the mixing bowl. Blend the mushrooms in the food processor, and add them to the mixing bowl. And lastly add the drained lentils to the mixing bowl. Mix the tofu, walnuts, mushrooms and lentils together and set aside.\n\nIn a large frying pan, sauté the onion in the olive oil until soft. Then add the tofu, walnut, mushroom and lentil mix to the frying pan, along with the garlic, basil, oregano, cayenne pepper and soy sauce, and cook for a few minutes until the mixture is not too wet.\n\nAdd the tomato paste and crushed tomatoes and fry for a few minutes longer, until you reach a bolognese consistency.\n\nStir in the sugar and as much salt and pepper as you feel like.\n\nIn the meantime, cook the spaghetti according to the package instructions. Serve with the bolognese mix on top of the spaghetti, or if you prefer, mixed together.",
    state: :approved_for_recipe_of_the_day
  )
  puts "Recipe written"

  puts "Preparing ingredients..."
  Ingredient.create!(
    recipe: spag_bol,
    food: "extra firm tofu",
    amount: '220',
    unit: Ingredient.inhuman_units[:gram]
  )

  Ingredient.create!(
    recipe: spag_bol,
    food: "walnuts",
    amount: '100',
    unit: Ingredient.inhuman_units[:gram]
  )

  Ingredient.create!(
    recipe: spag_bol,
    food: "brown mushrooms",
    amount: '500',
    unit: Ingredient.inhuman_units[:gram]
  )

  Ingredient.create!(
    recipe: spag_bol,
    food: "brown lentils",
    amount: '1',
    unit: Ingredient.inhuman_units[:can],
    preparation: "drained"
  )

  Ingredient.create!(
    recipe: spag_bol,
    food: "onion",
    amount: '1',
    preparation: "chopped"
  )

  Ingredient.create!(
    recipe: spag_bol,
    food: "olive oil",
    amount: '1',
    unit: Ingredient.inhuman_units[:tablespoon]
  )

  Ingredient.create!(
    recipe: spag_bol,
    food: "garlic",
    amount: '3',
    unit: Ingredient.inhuman_units[:clove],
    preparation: "crushed"
  )

  Ingredient.create!(
    recipe: spag_bol,
    food: "dried basil",
    amount: '1',
    unit: Ingredient.inhuman_units[:teaspoon]
  )

  Ingredient.create!(
    recipe: spag_bol,
    food: "oregano",
    amount: '1',
    unit: Ingredient.inhuman_units[:teaspoon]
  )

  Ingredient.create!(
    recipe: spag_bol,
    food: "cayenne pepper",
    amount: 'Half',
    unit: Ingredient.inhuman_units[:teaspoon]
  )

  Ingredient.create!(
    recipe: spag_bol,
    food: "soy sauce",
    amount: '1',
    unit: Ingredient.inhuman_units[:tablespoon]
  )

  Ingredient.create!(
    recipe: spag_bol,
    food: "tomato paste",
    amount: '130',
    unit: Ingredient.inhuman_units[:gram]
  )

  Ingredient.create!(
    recipe: spag_bol,
    food: "crushed tomatoes",
    amount: '1',
    unit: Ingredient.inhuman_units[:can]
  )

  Ingredient.create!(
    recipe: spag_bol,
    food: "brown sugar",
    amount: '1',
    unit: Ingredient.inhuman_units[:tablespoon]
  )

  Ingredient.create!(
    recipe: spag_bol,
    food: "sea salt"
  )

  Ingredient.create!(
    recipe: spag_bol,
    food: "black pepper"
  )

  Ingredient.create!(
    recipe: spag_bol,
    food: "wholewheat spaghetti",
    amount: '250',
    unit: Ingredient.inhuman_units[:gram]
  )
  puts "Ingredients prepped"

  puts "Taking photo..."
  File.open('app/assets/images/seed_photos/spaghetti_bolognese.jpg') { |f| spag_bol.photo = f }
  spag_bol.save
  puts "Photo snapped"

  puts "Spaghetti bolognese served"


  puts "Cleaning protein shakers..."
  Recipe.where(name: VEGAN_PROTEIN_SHAKE).destroy_all
  puts "Protein shakers clean"

  puts "Making protein shake..."
  puts "Writing recipe..."
  protein_shake = Recipe.create!(
    user: user,
    name: VEGAN_PROTEIN_SHAKE,
    process: "Add all ingredients to a blender. Blend on a high speed until smooth. Serve. Simple.",
    state: :approved_for_recipe_of_the_day
  )
  puts "Recipe written"

  puts "Preparing ingredients..."
  Ingredient.create!(
    recipe: protein_shake,
    food: "frozen banana",
    amount: '1',
    preparation: "cut into blendable-sized pieces"
  )

  Ingredient.create!(
    recipe: protein_shake,
    food: "hemp seeds",
    amount: '2',
    unit: Ingredient.inhuman_units[:tablespoon]
  )

  Ingredient.create!(
    recipe: protein_shake,
    food: "oats",
    amount: '60',
    unit: Ingredient.inhuman_units[:millilitre]
  )

  Ingredient.create!(
    recipe: protein_shake,
    food: "peanut butter",
    amount: '2',
    unit: Ingredient.inhuman_units[:tablespoon]
  )

  Ingredient.create!(
    recipe: protein_shake,
    food: "chia seeds",
    amount: '1',
    unit: Ingredient.inhuman_units[:tablespoon]
  )

  Ingredient.create!(
    recipe: protein_shake,
    food: "cacao powder",
    amount: '2',
    unit: Ingredient.inhuman_units[:tablespoon]
  )

  Ingredient.create!(
    recipe: protein_shake,
    food: "plant-based milk",
    amount: '470',
    unit: Ingredient.inhuman_units[:millilitre]
  )

  Ingredient.create!(
    recipe: protein_shake,
    food: "dates",
    amount: '2',
    optional: true
  )
  puts "Ingredients prepped"

  puts "Taking photo..."
  File.open('app/assets/images/seed_photos/vegan_protein_shake.jpg') { |f| protein_shake.photo = f }
  protein_shake.save
  puts "Photo snapped"

  puts "Protein shake served"


  puts "Cleaning avocado smashers..."
  Recipe.where(name: SMASHED_AVOCADO_ON_WHOLEWHEAT_TOAST).destroy_all
  puts "Avocado smashers clean"

  puts "Making smashed avo..."
  puts "Writing recipe..."
  smashed_avo = Recipe.create!(
    user: user,
    name: SMASHED_AVOCADO_ON_WHOLEWHEAT_TOAST,
    process: "Place the avocado, chilli flakes, garlic, lime juice, salt, and olive oil in a bowl and mash it all together with a fork until you reach your desired consistency.\n\nSpread it on the toast and garnish with the coriander leaves (or anything else you fancy).",
    state: :approved_for_recipe_of_the_day
  )
  puts "Recipe written"

  puts "Preparing ingredients..."
  Ingredient.create!(
    recipe: smashed_avo,
    food: "avocado",
    amount: '1',
    preparation: "de-skinned and de-stoned"
  )

  Ingredient.create!(
    recipe: smashed_avo,
    food: "chilli flakes",
    amount: '1',
    unit: Ingredient.inhuman_units[:pinch]
  )

  Ingredient.create!(
    recipe: smashed_avo,
    food: "garlic",
    amount: '1',
    unit: Ingredient.inhuman_units[:clove],
    preparation: "crushed and finely chopped"
  )

  Ingredient.create!(
    recipe: smashed_avo,
    food: "lime juice",
    amount: '1',
    unit: Ingredient.inhuman_units[:tablespoon]
  )

  Ingredient.create!(
    recipe: smashed_avo,
    food: "sea salt"
  )

  Ingredient.create!(
    recipe: smashed_avo,
    food: "olive oil",
    unit: Ingredient.inhuman_units[:dash]
  )

  Ingredient.create!(
    recipe: smashed_avo,
    food: "wholewheat toast",
    amount: '1',
    unit: Ingredient.inhuman_units[:slice]
  )

  Ingredient.create!(
    recipe: smashed_avo,
    food: "fresh coriander",
    amount: 'A few',
    unit: Ingredient.inhuman_units[:sprig],
    preparation: "chopped",
    optional: true
  )
  puts "Ingredients prepped"

  puts "Taking photo..."
  File.open('app/assets/images/seed_photos/smashed_avocado_on_wholewheat_toast.jpg') { |f| smashed_avo.photo = f }
  smashed_avo.save
  puts "Photo snapped"

  puts "Smashed avo served"


  puts "Cleaning pita trays..."
  Recipe.where(name: WHOLEWHEAT_PITA_BREADS).destroy_all
  puts "Pita trays clean"

  puts "Making pita breads..."
  puts "Writing recipe..."
  pita_breads = Recipe.create!(
    user: user,
    name: WHOLEWHEAT_PITA_BREADS,
    process: "In a large bowl, sift together half of the flour, the yeast, and the salt if using. Then pour in the water and start kneading the mixture together.\n\nGradually add-in more flour until the mixture starts cleaning the sides of the bowl (so you probably won't need to use all of it), and continue kneading until the dough is smooth and fleshy; about 5 minutes longer.\n\nNow form the dough into 10 balls, and on a floured surface, with a floured rolling-pin, roll each ball into circles about 15cm in diameter. They should be about half a centimetre thick.\n\nEither on a couple of non-stick baking trays, or on baking trays lined with cooking paper (or even non-stick baking trays lined with cooking paper), place each of the pita breads and allow them to rise for 30 minutes.\n\nIn the meantime, preheat your oven to 260°C. I'm not normally a big fan of preheating ovens; it just seems like a waste of energy, when the food could be sitting in the oven while it's heating up. Like those people that warm up before going jogging, you just want to say to them, what are you doing?\n\nHowever, in this case, do make sure that the over is fully preheated. For the pita breads to rise, the oven needs to be hot enough that the outside of the pitas get sealed with some moisture remaining in the middle. That moisture heating-up with nowhere to escape is what causes the pitas to rise into pockets.\n\nBefore putting them into the oven, flip the pitas over, then place them in the bottom of the oven where they'll be exposed to the instant heat of the heating element. For this reason, if you've got a small oven perhaps cook each of the baking trays separately.\n\nCook the pitas until they rise properly; about 5 minutes. Then remove them from the oven.\n\nThey'll be initially hard, but will soften as they cool.\n\nIf not eating immediately, store them in an air-tight container while still warm.",
    state: :approved_for_feature
  )
  puts "Recipe written"

  puts "Preparing ingredients..."
  Ingredient.create!(
    recipe: pita_breads,
    food: "wholewheat flour",
    amount: '950',
    unit: Ingredient.inhuman_units[:millilitre]
  )

  Ingredient.create!(
    recipe: pita_breads,
    food: "dry yeast",
    amount: '1',
    unit: Ingredient.inhuman_units[:tablespoon]
  )

  Ingredient.create!(
    recipe: pita_breads,
    food: "warm water",
    amount: '295',
    unit: Ingredient.inhuman_units[:millilitre]
  )

  Ingredient.create!(
    recipe: pita_breads,
    food: "salt",
    amount: 'half',
    unit: Ingredient.inhuman_units[:teaspoon],
    optional: true
  )
  puts "Ingredients prepped"

  puts "Taking photo..."
  File.open('app/assets/images/seed_photos/wholewheat_pita_breads.jpg') { |f| pita_breads.photo = f }
  pita_breads.save
  puts "Photo snapped"

  puts "Pita breads served"


  puts "Cleaning hummus pots..."
  Recipe.where(name: HUMMUS_TOAST).destroy_all
  puts "Hummus pots clean"

  puts "Making hummus toast..."
  puts "Writing recipe..."
  hummus_on_toast = Recipe.create!(
    user: user,
    name: HUMMUS_TOAST,
    process: "Spread a generous serving of hummus (homemade is best) onto the each slice of wholewheat bread (homemade is best), and add four of the tomato eighths onto each slice.\n\nCook under a preheated grill on a high heat for as long as you can without burning the bread.\n\nThen drizzle with balsamic vinegar,  sprinkle on some parsley, and optionally top with salt and pepper and enjoy.",
    state: :approved_for_recipe_of_the_day
  )
  puts "Recipe written"

  puts "Preparing ingredients..."
  Ingredient.create!(
    recipe: hummus_on_toast,
    food: "wholewheat bread",
    amount: '2',
    unit: Ingredient.inhuman_units[:slice]
  )

  Ingredient.create!(
    recipe: hummus_on_toast,
    food: "tomato",
    amount: '1',
    preparation: "cut into eighths"
  )

  Ingredient.create!(
    recipe: hummus_on_toast,
    food: "hummus"
  )

  Ingredient.create!(
    recipe: hummus_on_toast,
    food: "dried parsley"
  )

  Ingredient.create!(
    recipe: hummus_on_toast,
    food: "balsamic vinegar"
  )

  Ingredient.create!(
    recipe: hummus_on_toast,
    food: "sea salt",
    optional: true
  )

  Ingredient.create!(
    recipe: hummus_on_toast,
    food: "black pepper",
    optional: true
  )
  puts "Ingredients prepped"

  puts "Taking photo..."
  File.open('app/assets/images/seed_photos/hummus_toast.jpg') { |f| hummus_on_toast.photo = f }
  hummus_on_toast.save
  puts "Photo snapped"

  puts "Hummus toast served"



  puts "Setting featured recipes..."
  Recipe.update_highlighted_recipes
  puts "Featured recipes set"
end

