json.array! @recipes do |recipe|
  next unless recipe.available_to_show?

  json.extract! recipe, :id, :name
  json.author do
    json.id recipe.user.id
    json.username recipe.user.username
  end
end
