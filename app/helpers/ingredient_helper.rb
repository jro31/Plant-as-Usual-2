# SPEC THIS WHOLE FILE
module IngredientHelper
  def ingredient_input_collection(column, units)
    is_unit_column?(column) ? units : false
  end

  def ingredient_input_placeholder(column)
    is_unit_column?(column) ? false : ingredient_placeholder_text(Ingredient::USER_EDITABLE_COLUMNS[column], optional: is_amount_column?(column) || is_preparation_column?(column))
  end

  def ingredient_input_prompt(column)
    is_unit_column?(column) ? ingredient_placeholder_text(Ingredient::USER_EDITABLE_COLUMNS[:unit], optional: true) : false
  end

  def ingredient_placeholder_text(column, optional = false)
    "#{Ingredient.user_facing_editable_column_names[column]}#{optional ? ' (optional)' : ''}"
  end

  private

  def is_amount_column?(column)
    Ingredient::USER_EDITABLE_COLUMNS[column] === Ingredient::USER_EDITABLE_COLUMNS[:amount]
  end

  def is_unit_column?(column)
    Ingredient::USER_EDITABLE_COLUMNS[column] === Ingredient::USER_EDITABLE_COLUMNS[:unit]
  end

  def is_preparation_column?(column)
    Ingredient::USER_EDITABLE_COLUMNS[column] === Ingredient::USER_EDITABLE_COLUMNS[:preparation]
  end
end
