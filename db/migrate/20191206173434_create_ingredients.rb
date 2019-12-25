class CreateIngredients < ActiveRecord::Migration[6.0]
  def change
    create_table :ingredients do |t|
      t.references :recipe, null: false, foreign_key: true
      t.string :name
      t.float :amount
      t.string :amount_description
      t.references :unit, null: true, foreign_key: true
      t.string :preparation
      t.boolean :optional, default: false

      t.timestamps
    end
  end
end
