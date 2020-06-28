class AddStateToRecipe < ActiveRecord::Migration[6.0]
  def change
    add_column :recipes, :state, :string
    add_column :recipes, :declined_reason, :string
    add_column :recipes, :last_featured, :date
    add_column :recipes, :last_recipe_of_the_day, :date
    remove_column :recipes, :servings, :integer
    remove_column :recipes, :cooking_time_minutes, :integer
    remove_column :recipes, :deleted, :boolean
  end
end
