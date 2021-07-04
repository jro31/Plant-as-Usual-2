require 'rails_helper'

describe RecipesController, type: :controller do
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe) }
  before { sign_in user }

  describe 'GET #index' do
    render_views
    context 'user is signed-in' do
      context '@recipes contains recipes' do
        let!(:recipe) { create(:recipe) }
        it 'returns http success' do
          get :index
          expect(response).to be_successful
        end
      end

      context '@recipes does not contain any recipes' do
        context 'recipe filter is user_recipes' do
          context 'searched for user is current user' do
            it 'returns http success' do
              get :index, params: { recipe_filter: 'user_recipes', user_id: user.id }
              expect(response).to be_successful
            end
          end

          context 'searched for user is not current user' do
            let(:searched_for_user) { create(:user) }
            it 'returns http success' do
              get :index, params: { recipe_filter: 'user_recipes', user_id: searched_for_user.id }
              expect(response).to be_successful
            end
          end
        end

        context 'recipe filter is user_favourites' do
          it 'returns http success' do
            get :index, params: { recipe_filter: 'user_favourites' }
            expect(response).to be_successful
          end
        end

        context 'recipe filter is search' do
          it 'returns http success' do
            get :index, params: { recipe_filter: 'search', query: 'areallylongandcomplicatedquerythatwontreturnanyresults' }
            expect(response).to be_successful
          end
        end

        context 'recipe filter does not exist' do
          it 'returns http success' do
            get :index
            expect(response).to be_successful
          end
        end
      end

      describe 'filtered_recipes' do
        let!(:current_user_recipe) { create(:recipe, user: user) }
        let(:other_user) { create(:user) }
        let!(:other_user_recipe) { create(:recipe_with_ingredients, user: other_user, name: 'Pizza') }
        context 'recipe filter is user_recipes' do
          context 'searched for user is the current user' do
            context 'the current user has recipes' do
              it 'assigns the current user recipes to @recipes' do
                get :index, params: { recipe_filter: 'user_recipes', user_id: user.id }
                expect(assigns(:recipes)).to eq([current_user_recipe])
              end
            end

            context 'the current user does not have any recipes' do
              let!(:current_user_recipe) { nil }
              it 'does not assign any recipes to @recipes' do
                get :index, params: { recipe_filter: 'user_recipes', user_id: user.id }
                expect(assigns(:recipes)).to eq([])
              end
            end
          end

          context 'searched for user is not the current user' do
            context 'the searched for user has recipes' do
              it 'assigns the searched for users recipes to @recipes' do
                get :index, params: { recipe_filter: 'user_recipes', user_id: other_user.id }
                expect(assigns(:recipes)).to eq([other_user_recipe])
              end
            end

            context 'the searched for user does not have any recipes' do
              let!(:other_user_recipe) { nil }
              it 'does not assign any recipes to @recipes' do
                get :index, params: { recipe_filter: 'user_recipes', user_id: other_user.id }
                expect(assigns(:recipes)).to eq([])
              end
            end
          end

          context 'no user is searched for' do
            it 'assigns nil to @recipes' do
              get :index, params: { recipe_filter: 'user_recipes' }
              expect(assigns(:recipes)).to eq(nil)
            end
          end
        end

        context 'recipe filter is user_favourites' do
          context 'current user favourites exist' do
            let!(:current_user_favourite_recipe) { create(:user_favourite_recipe, user: user, recipe: other_user_recipe) }
            let!(:other_user_favourite_recipe) { create(:user_favourite_recipe, user: other_user, recipe: current_user_recipe) }
            it 'assigns @recipes the current user favourited recipe' do
              get :index, params: { recipe_filter: 'user_favourites' }
              expect(assigns(:recipes)).to eq([other_user_recipe])
            end
          end

          context 'user favourites do not exist' do
            it 'does not assign any recipes to @recipes' do
              get :index, params: { recipe_filter: 'user_favourites' }
              expect(assigns(:recipes)).to eq([])
            end
          end
        end

        context 'recipe filter is search' do
          context 'search returns recipes' do
            it 'assigns the relevant recipes to @recipes' do
              get :index, params: { recipe_filter: 'search', query: 'pizza' }
              expect(assigns(:recipes)).to eq([other_user_recipe])
            end
          end

          context 'search does not return any recipes' do
            it 'does not assign any recipes to @recipes' do
              get :index, params: { recipe_filter: 'search', query: 'areallylongandcomplicatedquerythatwontreturnanyresults' }
              expect(assigns(:recipes)).to eq([])
            end
          end
        end

        context 'recipe filter is something else' do
          it 'assigns all recipes to @recipes' do
            get :index, params: { recipe_filter: 'wtf?' }
            expect(assigns(:recipes)).to include(current_user_recipe, other_user_recipe)
          end
        end

        context 'recipe filter does not exist' do
          it 'assigns all recipes to @recipes' do
            get :index
            expect(assigns(:recipes)).to include(current_user_recipe, other_user_recipe)
          end
        end
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
    let(:params) { { recipe: { name: 'Pesto pasta' } } }
    context 'user is signed-in' do
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
      it 'updates the photo urls' do
        expect(recipe.photo.url).to eq(nil)
        expect(recipe.photo.thumb.url).to eq(nil)
        expect(recipe.photo.max_height_350.url).to eq(nil)
        expect(recipe.photo.max_height_500.url).to eq(nil)
        expect(recipe.photo.max_height_720.url).to eq(nil)
        expect(recipe.photo.max_height_1000.url).to eq(nil)
        expect(recipe.photo.max_width_500.url).to eq(nil)
        expect(recipe.photo.max_width_1000.url).to eq(nil)
        patch :upload_photo, params: params, format: :js
        expect(recipe.reload.photo.url).to eq("/uploads/spec/recipe/photo/#{recipe.id}/test-photo.jpg")
        expect(recipe.photo.thumb.url).to eq("/uploads/spec/recipe/photo/#{recipe.id}/thumb_test-photo.jpg")
        expect(recipe.photo.max_height_350.url).to eq("/uploads/spec/recipe/photo/#{recipe.id}/max_height_350_test-photo.jpg")
        expect(recipe.photo.max_height_500.url).to eq("/uploads/spec/recipe/photo/#{recipe.id}/max_height_500_test-photo.jpg")
        expect(recipe.photo.max_height_720.url).to eq("/uploads/spec/recipe/photo/#{recipe.id}/max_height_720_test-photo.jpg")
        expect(recipe.photo.max_height_1000.url).to eq("/uploads/spec/recipe/photo/#{recipe.id}/max_height_1000_test-photo.jpg")
        expect(recipe.photo.max_width_500.url).to eq("/uploads/spec/recipe/photo/#{recipe.id}/max_width_500_test-photo.jpg")
        expect(recipe.photo.max_width_1000.url).to eq("/uploads/spec/recipe/photo/#{recipe.id}/max_width_1000_test-photo.jpg")
      end
    end

    context 'current user is admin' do
      let(:recipe_owner) { create(:user) }
      before { user.update(admin: true) }
      before { recipe.update(user: recipe_owner) }
      it 'updates the photo urls' do
        expect(recipe.photo.url).to eq(nil)
        expect(recipe.photo.thumb.url).to eq(nil)
        expect(recipe.photo.max_height_350.url).to eq(nil)
        expect(recipe.photo.max_height_500.url).to eq(nil)
        expect(recipe.photo.max_height_720.url).to eq(nil)
        expect(recipe.photo.max_height_1000.url).to eq(nil)
        expect(recipe.photo.max_width_500.url).to eq(nil)
        expect(recipe.photo.max_width_1000.url).to eq(nil)
        patch :upload_photo, params: params, format: :js
        expect(recipe.reload.photo.url).to eq("/uploads/spec/recipe/photo/#{recipe.id}/test-photo.jpg")
        expect(recipe.photo.thumb.url).to eq("/uploads/spec/recipe/photo/#{recipe.id}/thumb_test-photo.jpg")
        expect(recipe.photo.max_height_350.url).to eq("/uploads/spec/recipe/photo/#{recipe.id}/max_height_350_test-photo.jpg")
        expect(recipe.photo.max_height_500.url).to eq("/uploads/spec/recipe/photo/#{recipe.id}/max_height_500_test-photo.jpg")
        expect(recipe.photo.max_height_720.url).to eq("/uploads/spec/recipe/photo/#{recipe.id}/max_height_720_test-photo.jpg")
        expect(recipe.photo.max_height_1000.url).to eq("/uploads/spec/recipe/photo/#{recipe.id}/max_height_1000_test-photo.jpg")
        expect(recipe.photo.max_width_500.url).to eq("/uploads/spec/recipe/photo/#{recipe.id}/max_width_500_test-photo.jpg")
        expect(recipe.photo.max_width_1000.url).to eq("/uploads/spec/recipe/photo/#{recipe.id}/max_width_1000_test-photo.jpg")
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
