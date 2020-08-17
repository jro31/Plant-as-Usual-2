require 'rails_helper'

describe UserFavouriteRecipesController, type: :controller do
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe) }
  before { sign_in user }

  describe 'POST #create' do
    let(:params) { { recipe_id: recipe.id } }

    context 'current user is signed-in' do
      it 'creates a UserFavouriteRecipe' do
        expect { post :create, params: params }.to change(UserFavouriteRecipe, :count).by(1)
      end

      it 'gives the UserFavouriteRecipe the correct data' do
        post :create, params: params
        expect(UserFavouriteRecipe.last.user).to eq(user)
        expect(UserFavouriteRecipe.last.recipe).to eq(recipe)
      end
    end

    context 'current user is not signed-in' do
      before { sign_out user }
      it 'does not create a UserFavouriteRecipe' do
        expect { post :create, params: params }.to change(UserFavouriteRecipe, :count).by(0)
      end
    end
  end
end
