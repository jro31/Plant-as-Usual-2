class CreateIngredients < ActiveRecord::Migration[6.0]
  def change
    create_table :ingredients do |t|
      t.references :recipe, null: false, foreign_key: true
      t.string :name
      t.integer :amount
      t.references :unit, null: false, foreign_key: true
      t.boolean :optional, default: false

      t.timestamps
    end
  end
end
