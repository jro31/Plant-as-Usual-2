module IngredientHelper
  def ingredient_input_collection(column, units)
    is_unit_column?(column) ? units.map{ |unit| unit } : false
  end

  def ingredient_label_method(column)
    is_unit_column?(column) ? :second : nil
  end

  def ingredient_value_method(column)
    is_unit_column?(column) ? :first : nil
  end

  def ingredient_input_label(column)
    is_optional_column?(column) ? ingredient_placeholder_text(column) : false
  end

  def ingredient_input_placeholder(column)
    is_unit_column?(column) || is_optional_column?(column) ? false : ingredient_placeholder_text(column, optional: is_amount_column?(column) || is_preparation_column?(column))
  end

  def ingredient_input_prompt(column)
    is_unit_column?(column) ? ingredient_placeholder_text(column, optional: true) : false
  end

  private

  def is_amount_column?(column)
    Ingredient::USER_EDITABLE_COLUMNS[column.to_sym] === Ingredient::USER_EDITABLE_COLUMNS[:amount]
  end

  def is_unit_column?(column)
    Ingredient::USER_EDITABLE_COLUMNS[column.to_sym] === Ingredient::USER_EDITABLE_COLUMNS[:unit]
  end

  def is_preparation_column?(column)
    Ingredient::USER_EDITABLE_COLUMNS[column.to_sym] === Ingredient::USER_EDITABLE_COLUMNS[:preparation]
  end

  def is_optional_column?(column)
    Ingredient::USER_EDITABLE_COLUMNS[column.to_sym] === Ingredient::USER_EDITABLE_COLUMNS[:optional]
  end

  def ingredient_placeholder_text(column, optional: false)
    "#{Ingredient.user_facing_editable_column_names[Ingredient::USER_EDITABLE_COLUMNS[column.to_sym]]}#{optional ? ' (optional)' : ''}"
  end
end
