json.array! @recipes do |recipe|
  next unless recipe.available_to_show?

  json.extract! recipe, :id, :name
end
