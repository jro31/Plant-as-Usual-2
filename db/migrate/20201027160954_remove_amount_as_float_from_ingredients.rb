class RemoveAmountAsFloatFromIngredients < ActiveRecord::Migration[6.0]
  def change
    remove_column :ingredients, :amount_as_float, :float
  end
end
