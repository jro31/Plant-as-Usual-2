require 'rails_helper'

describe IngredientsController, type: :controller do
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe) }
  before { sign_in user }

  describe 'POST #create' do
    let(:params) { { recipe_id: recipe.id } }

    context 'current user is recipe owner' do
      before { recipe.update(user: user) }
      it 'creates an ingredient' do
        expect { post :create, params: params, format: :js }.to change(Ingredient, :count).by(1)
      end

      it 'sets the recipe on the ingredient' do
        post :create, params: params, format: :js
        expect(Ingredient.last.recipe).to eq(recipe)
      end
    end

    context 'current user is admin' do
      let(:recipe_owner) { create(:user) }
      before { user.update(admin: true) }
      before { recipe.update(user: recipe_owner) }
      it 'creates an ingredient' do
        expect { post :create, params: params, format: :js }.to change(Ingredient, :count).by(1)
      end

      it 'sets the recipe on the ingredient' do
        post :create, params: params, format: :js
        expect(Ingredient.last.recipe).to eq(recipe)
      end
    end

    context 'current user is imposter' do
      let(:recipe_owner) { create(:user) }
      before { recipe.update(user: recipe_owner) }
      it 'throws a not authorised error' do
        expect { post :create, params: params, format: :js }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'current user is not signed-in' do
      before { sign_out user }
      it 'does not create an ingredient' do
        expect { post :create, params: params, format: :js }.to change(Ingredient, :count).by(0)
      end
    end
  end

  describe 'PATCH #update' do
    let(:ingredient) { create(:ingredient, recipe: recipe) }
    let(:params) { { id: ingredient.id, recipe_id: recipe.id, ingredient: { amount: '3', unit: 'clove', food: 'garlic', preparation: 'crushed', optional: true } } }
    context 'current user is recipe owner' do
      before { recipe.update(user: user) }
      context 'food is present' do
        context 'the recipe is the ingredient recipe' do
          it 'updates the amount' do
            expect(ingredient.amount).not_to eq('3')
            patch :update, params: params
            expect(ingredient.reload.amount).to eq('3')
          end

          it 'updates the unit' do
            expect(ingredient.unit).not_to eq('clove')
            patch :update, params: params
            expect(ingredient.reload.unit).to eq('clove')
          end

          it 'updates the food' do
            expect(ingredient.food).not_to eq('garlic')
            patch :update, params: params
            expect(ingredient.reload.food).to eq('garlic')
          end

          it 'updates the preparation' do
            expect(ingredient.preparation).not_to eq('crushed')
            patch :update, params: params
            expect(ingredient.reload.preparation).to eq('crushed')
          end

          it 'updates optional' do
            expect(ingredient.optional).not_to eq(true)
            patch :update, params: params
            expect(ingredient.reload.optional).to eq(true)
          end

          it 'updates the recipe state to incomplete' do
            expect(recipe.state).not_to eq('incomplete')
            patch :update, params: params
            expect(recipe.reload.state).to eq('incomplete')
          end
        end

        context 'the recipe is not the ingredient recipe' do
          let(:imposter_recipe) { create(:recipe, user: user) }
          let(:params) { { id: ingredient.id, recipe_id: imposter_recipe.id, ingredient: { amount: '1', unit: 'clove', food: 'garlic', preparation: 'crushed', optional: true } } }
          it 'throws a wrong recipe error' do
            expect { patch :update, params: params }.to raise_error(IngredientsController::WrongRecipeError)
          end
        end
      end

      context 'food is not present' do
        let(:params) { { id: ingredient.id, recipe_id: recipe.id, ingredient: { amount: '1', unit: 'clove', food: '', preparation: 'crushed', optional: true } } }
        it 'does not update the ingredient' do
          patch :update, params: params
          ingredient.reload
          expect(ingredient.amount).not_to eq('3')
          expect(ingredient.unit).not_to eq('clove')
          expect(ingredient.food).not_to eq('garlic')
          expect(ingredient.preparation).not_to eq('crushed')
          expect(ingredient.optional).not_to eq(true)
        end

        it 'does not change the recipe state to incomplete' do
          patch :update, params: params
          expect(recipe.reload.state).not_to eq('incomplete')
        end
      end
    end

    context 'current user is admin' do
      let(:recipe_owner) { create(:user) }
      before { user.update(admin: true) }
      before { recipe.update(user: recipe_owner) }
      it 'updates the ingredient' do
        patch :update, params: params
        ingredient.reload
        expect(ingredient.amount).to eq('3')
        expect(ingredient.unit).to eq('clove')
        expect(ingredient.food).to eq('garlic')
        expect(ingredient.preparation).to eq('crushed')
        expect(ingredient.optional).to eq(true)
      end

      it 'updates the recipe state to incomplete' do
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
      it 'does not call update on ingredient' do
        expect(ingredient).to receive(:update).never
        patch :update, params: params
      end

      it 'does not update the ingredient' do
        patch :update, params: params
        ingredient.reload
        expect(ingredient.amount).not_to eq('3')
        expect(ingredient.unit).not_to eq('clove')
        expect(ingredient.food).not_to eq('garlic')
        expect(ingredient.preparation).not_to eq('crushed')
        expect(ingredient.optional).not_to eq(true)
      end

      it 'does not change the recipe state to incomplete' do
        patch :update, params: params
        expect(recipe.reload.state).not_to eq('incomplete')
      end
    end
  end

  describe 'DELETE #destroy' do
    # COMPLETE THIS
  end
end
