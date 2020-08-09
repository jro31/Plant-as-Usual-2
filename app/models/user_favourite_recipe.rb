class UserFavouriteRecipe < ApplicationRecord
  belongs_to :user
  belongs_to :recipe

  # ADD VALIDATION FOR THE UNIQUENESS OF THE USER/RECIPE COMBO
end
