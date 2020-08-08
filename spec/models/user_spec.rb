require 'rails_helper'

describe User, type: :model do
  it { should have_many :recipes }
  it { should have_many :user_favourite_recipes }
  it { should have_many :favourites }

  let(:user) { create(:user) }

  describe 'User.favourites' do
    let(:recipe_1) { create(:recipe) }
    let!(:recipe_2) { create(:recipe) }
    let!(:user_favourite_recipe_1) { create(:user_favourite_recipe, user: user, recipe: recipe_1) }
    let!(:user_favourite_recipe_2) { create(:user_favourite_recipe, user: user, recipe: recipe_2) }
    it 'returns their favourite recipes' do
      expect(user.favourites).to include(recipe_1, recipe_2)
    end
  end

  describe 'destroying a user destroys their recipes' do
    let!(:recipe) { create(:recipe, id: 999, user: user) }
    it 'destroys the recipe' do
      expect(Recipe.find(999)).to eq(recipe)
      user.destroy
      expect { Recipe.find(999) }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end

  describe 'destroying a user destroys associated user_favourite_recipes' do
    let(:recipe) { create(:recipe) }
    let!(:user_favourite_recipe) { create(:user_favourite_recipe, id: 111, user: user, recipe: recipe) }
    it 'destroys the user_favourite_recipe' do
      expect(UserFavouriteRecipe.find(111)).to eq(user_favourite_recipe)
      user.destroy
      expect { UserFavouriteRecipe.find(111) }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end
