require 'rails_helper'

describe Recipe, type: :model do
  it { should belong_to :user }
  it { should have_many :ingredients }

  describe 'something' do
    context 'recipe' do
      let(:recipe) { create(:recipe) }
      it 'does something' do
        puts recipe.name
        puts recipe.process
        puts recipe.cooking_time_minutes
      end
    end

    context 'recipe_with_ingredients' do
      let(:recipe_with_ingredients) { create(:recipe_with_ingredients) }
      it 'does something else' do
        puts recipe_with_ingredients.name
        puts recipe_with_ingredients.ingredients.first.name
        puts recipe_with_ingredients.ingredients.last.name
      end
    end
  end
end
