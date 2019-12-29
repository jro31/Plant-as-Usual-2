require 'rails_helper'

describe Ingredient, type: :model do
  it { should belong_to :recipe }
  it { should belong_to(:unit).optional }

  describe 'something' do
    context 'ingredient' do
      let(:ingredient) { create(:ingredient) }
      it 'does something' do
        puts ingredient.name
      end
    end

    context 'ingredient_with_recipe' do
      let(:ingredient_with_recipe) { create(:ingredient_with_recipe) }
      it 'does something else' do
        puts ingredient_with_recipe.name
        puts ingredient_with_recipe.recipe.name
      end
    end
  end
end
