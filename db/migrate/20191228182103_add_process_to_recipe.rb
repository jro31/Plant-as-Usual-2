class AddProcessToRecipe < ActiveRecord::Migration[6.0]
  def change
    remove_column :recipes, :method, :text
    add_column :recipes, :process, :text
  end
end
