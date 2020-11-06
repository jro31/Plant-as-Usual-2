json.extract! @recipe, :id, :name, :process, :photo
json.ingredients @recipe.ingredients do |ingredient|
  json.extract! ingredient, :id, :recipe_id, :amount, :unit, :food, :preparation, :optional
end
json.author do
  json.id @recipe.user.id
  json.username @recipe.user.username
  json.twitter_handle @recipe.user.twitter_handle
  json.instagram_username @recipe.user.instagram_handle
  json.website @recipe.user.website_url
end
