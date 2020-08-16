require 'rails_helper'

describe RecipesController, type: :controller do
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe) }
  before { sign_in user }

  describe 'GET #index' do
    context 'user is signed-in' do
      it 'returns http success' do
        get :index
        expect(response).to be_successful
      end
    end

    context 'user is not signed-in' do
      it 'returns http success' do
        sign_out user
        get :index
        expect(response).to be_successful
      end
    end
  end

  describe 'POST #create' do
    context 'user is signed-in' do
      let(:params) { { recipe: { name: 'Pesto pasta' } } }

      it 'creates a recipe' do
        expect { post :create, params: params }.to change(Recipe, :count).by(1)
      end

      it 'gives the recipe the correct name and user' do
        post :create, params: params
        expect(Recipe.last.name).to eq('Pesto pasta')
        expect(Recipe.last.user).to eq(user)
      end

      it 'redirects to the recipe' do
        post :create, params: params
        expect(response).to redirect_to recipe_path(Recipe.last)
      end
    end

    context 'user is not signed-in' do
      before { sign_out user }
      let(:params) { { recipe: { name: 'Pesto pasta' } } }

      it 'does not create a recipe' do
        expect{ post :create, params: params }.to change(Recipe, :count).by(0)
      end

      it 'redirects to the sign-in page' do
        post :create, params: params
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #show' do
    context 'user is signed-in' do
      it 'returns http success' do
        get :show, params: { id: recipe.id }
        expect(response).to be_successful
      end
    end

    context 'user is not signed-in' do
      it 'returns http success' do
        sign_out user
        get :show, params: { id: recipe.id }
        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH #update' do
    let(:params) { { id: recipe.id, recipe: { name: 'Pesto pasta', process: 'Make pesto and mix with pasta' } } }
    context 'current user is recipe owner' do
      before { recipe.update(user: user) }
      it 'updates the recipe name' do
        expect(recipe.name).not_to eq('Pesto pasta')
        patch :update, params: params
        expect(recipe.reload.name).to eq('Pesto pasta')
      end

      it 'updates the recipe process' do
        expect(recipe.process).not_to eq('Make pesto and mix with pasta')
        patch :update, params: params
        expect(recipe.reload.process).to eq('Make pesto and mix with pasta')
      end

      it 'changes the recipe state to incomplete' do
        expect(recipe.state).not_to eq('incomplete')
        patch :update, params: params
        expect(recipe.reload.state).to eq('incomplete')
      end
    end

    context 'current user is admin' do
      let(:recipe_owner) { create(:user) }
      before { user.update(admin: true) }
      before { recipe.update(user: recipe_owner) }
      it 'updates the recipe name' do
        expect(recipe.name).not_to eq('Pesto pasta')
        patch :update, params: params
        expect(recipe.reload.name).to eq('Pesto pasta')
      end

      it 'updates the recipe process' do
        expect(recipe.process).not_to eq('Make pesto and mix with pasta')
        patch :update, params: params
        expect(recipe.reload.process).to eq('Make pesto and mix with pasta')
      end

      it 'changes the recipe state to incomplete' do
        expect(recipe.state).not_to eq('incomplete')
        patch :update, params: params
        expect(recipe.reload.state).to eq('incomplete')
      end
    end

    context 'current user is imposter' do
      let(:recipe_owner) { create(:user) }
      before { recipe.update(user: recipe_owner) }
      it 'throws a not authorised error' do
        expect { patch :update, params: params }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'current user is not signed-in' do
      before { sign_out user }
      it 'does not call update on recipe' do
        expect(recipe).to receive(:update).never
        patch :update, params: params
      end

      it 'does not update the recipe name, process or state' do
        patch :update, params: params
        recipe.reload
        expect(recipe.name).not_to eq('Pesto pasta')
        expect(recipe.process).not_to eq('Make pesto and mix with pasta')
        expect(recipe.state).not_to eq('incomplete')
      end
    end
  end

  describe 'PATCH #upload_photo' do
    let(:test_photo) { fixture_file_upload(Rails.root.join('public', 'test-photo.jpg'), 'image/jpg') }
    let(:params) { { id: recipe.id, recipe: { photo: test_photo } } }
    context 'current user is recipe owner' do
      before { recipe.update(user: user) }
      it 'updates the photo url' do
        expect(recipe.photo.url).to eq(nil)
        patch :upload_photo, params: params, format: :js
        expect(recipe.reload.photo.url).to eq("http://plant-as-usual.s3.amazonaws.com/uploads/recipe/photo/#{recipe.id}/test-photo.jpg")
      end
    end

    context 'current user is admin' do
      let(:recipe_owner) { create(:user) }
      before { user.update(admin: true) }
      before { recipe.update(user: recipe_owner) }
      it 'updates the photo url' do
        expect(recipe.photo.url).to eq(nil)
        patch :upload_photo, params: params, format: :js
        expect(recipe.reload.photo.url).to eq("http://plant-as-usual.s3.amazonaws.com/uploads/recipe/photo/#{recipe.id}/test-photo.jpg")
      end
    end

    context 'current user is imposter' do
      let(:recipe_owner) { create(:user) }
      before { recipe.update(user: recipe_owner) }
      it 'throws a not authorised error' do
        expect { patch :upload_photo, params: params, format: :js }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'current user is not signed-in' do
      before { sign_out user }
      it 'does not call update on recipe' do
        expect(recipe).to receive(:update).never
        patch :upload_photo, params: params, format: :js
      end

      it 'does not update the photo url' do
        expect(recipe.photo.url).to eq(nil)
        patch :upload_photo, params: params, format: :js
        expect(recipe.reload.photo.url).to eq(nil)
      end
    end
  end

  describe 'PATCH #mark_as_complete' do
    let(:params) { { id: recipe.id } }
    before { recipe.update(state: :incomplete) }
    context 'current user is the recipe owner' do
      before { recipe.update(user: user) }
      it 'updates the recipe state to awaiting_approval' do
        expect(recipe.state).to eq('incomplete')
        patch :mark_as_complete, params: params
        expect(recipe.reload.state).to eq('awaiting_approval')
      end

      it 'redirects to the recipe' do
        patch :mark_as_complete, params: params
        expect(response).to redirect_to recipe_path(recipe)
      end
    end

    context 'current user is admin' do
      let(:recipe_owner) { create(:user) }
      before { user.update(admin: true) }
      before { recipe.update(user: recipe_owner) }
      it 'updates the recipe state to awaiting_approval' do
        expect(recipe.state).to eq('incomplete')
        patch :mark_as_complete, params: params
        expect(recipe.reload.state).to eq('awaiting_approval')
      end

      it 'redirects to the recipe' do
        patch :mark_as_complete, params: params
        expect(response).to redirect_to recipe_path(recipe)
      end
    end

    context 'current user is imposter' do
      let(:recipe_owner) { create(:user) }
      before { recipe.update(user: recipe_owner) }
      it 'throws a not authorised error' do
        expect { patch :mark_as_complete, params: params }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'current user is not signed-in' do
      before { sign_out user }
      it 'does not call complete on recipe' do
        expect(recipe).to receive(:complete).never
        patch :mark_as_complete, params: params
      end

      it 'does not update the recipe state' do
        expect(recipe.state).to eq('incomplete')
        patch :mark_as_complete, params: params
        expect(recipe.reload.state).to eq('incomplete')
      end
    end
  end

  describe 'DELETE #remove_as_favourite' do
    let!(:deleteable_user_favourite_recipe_1) { create(:user_favourite_recipe, user: user, recipe: recipe) }
    let!(:deleteable_user_favourite_recipe_2) { create(:user_favourite_recipe, user: user, recipe: recipe) }
    let!(:imposter_user_user_favourite_recipe) { create(:user_favourite_recipe, user: imposter_user, recipe: recipe) }
    let!(:imposter_recipe_user_favourite_recipe) { create(:user_favourite_recipe, user: user, recipe: imposter_recipe) }
    let(:imposter_user) { create(:user) }
    let(:imposter_recipe) { create(:recipe) }
    let(:params) { { id: recipe.id } }
    it 'deletes all user favourite recipes for the current user and the current recipe' do
      delete :remove_as_favourite, params: params
      expect { deleteable_user_favourite_recipe_1.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect { deleteable_user_favourite_recipe_2.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect { imposter_user_user_favourite_recipe.reload }.not_to raise_error
      expect { imposter_recipe_user_favourite_recipe.reload }.not_to raise_error
    end
  end

  describe 'DELETE #destroy' do
    let(:params) { { id: recipe.id } }
    context 'current user is the recipe owner' do
      before { recipe.update(user: user) }
      it 'destroys the recipe' do
        expect { recipe }.not_to raise_error
        delete :destroy, params: params
        expect { recipe.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'redirects to the homepage' do
        delete :destroy, params: params
        expect(response).to redirect_to root_path
      end
    end

    context 'current user is admin' do
      let(:recipe_owner) { create(:user) }
      before { user.update(admin: true) }
      before { recipe.update(user: recipe_owner) }
      it 'destroys the recipe' do
        expect { recipe }.not_to raise_error
        delete :destroy, params: params
        expect { recipe.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'redirects to the homepage' do
        delete :destroy, params: params
        expect(response).to redirect_to root_path
      end
    end

    context 'current user is imposter' do
      let(:recipe_owner) { create(:user) }
      before { recipe.update(user: recipe_owner) }
      it 'throws a not authorised error' do
        expect { delete :destroy, params: params }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'current user is not signed-in' do
      before { sign_out user }
      it 'does not call destroy on recipe' do
        expect(recipe).to receive(:destroy).never
        delete :destroy, params: params
      end

      it 'does not destroy the recipe' do
        expect { recipe }.not_to raise_error
        delete :destroy, params: params
        expect { recipe.reload }.not_to raise_error
      end
    end
  end
end
