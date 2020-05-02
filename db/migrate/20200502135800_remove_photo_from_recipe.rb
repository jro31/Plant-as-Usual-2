class RemovePhotoFromRecipe < ActiveRecord::Migration[6.0]
  def change
    remove_column :recipes, :photo, :string
  end
end
