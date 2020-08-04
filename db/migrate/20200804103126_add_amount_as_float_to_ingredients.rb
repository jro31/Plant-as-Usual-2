class AddAmountAsFloatToIngredients < ActiveRecord::Migration[6.0]
  def change
    add_column :ingredients, :amount_as_float, :float
  end
end
