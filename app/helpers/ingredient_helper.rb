module IngredientHelper
  def ingredient_input_display(ingredient, column, humanize = false, brackets = false) # SPEC THIS
    haml_tag :span, id: "ingredient-#{ingredient.id}-#{column}-display" do
      haml_concat("#{'(' if brackets}#{humanize ? ingredient.send(Ingredient::USER_EDITABLE_COLUMNS[column])&.humanize : ingredient.send(Ingredient::USER_EDITABLE_COLUMNS[column])}#{')' if brackets}")
    end
  end

  def ingredient_placeholder(column, optional = false) # SPEC THIS
    "#{Ingredient.user_facing_editable_column_names[column]}#{optional ? ' (optional)' : ''}"
  end
end
