class CreateRecipes < ActiveRecord::Migration[6.0]
  def change
    create_table :recipes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.text :method
      t.string :photo
      t.integer :servings
      t.integer :cooking_time_minutes
      t.boolean :deleted, default: false

      t.timestamps
    end
  end
end
