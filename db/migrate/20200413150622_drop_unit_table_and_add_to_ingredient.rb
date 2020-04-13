class DropUnitTableAndAddToIngredient < ActiveRecord::Migration[6.0]
  def change
    drop_table :units, force: :cascade
    remove_column :ingredients, :unit_id, :bigint
    add_column :ingredients, :unit, :string
    remove_column :ingredients, :amount, :float
    rename_column :ingredients, :amount_description, :amount
  end
end
