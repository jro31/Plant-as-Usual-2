require 'rails_helper'

describe AdminController, type: :controller do
  let(:user) { create(:user, admin: true) }
  let(:recipe) { create(:recipe, state: 'awaiting_approval') }
  before { sign_in user }

  describe 'GET #index' do
    context 'user is admin' do
      it 'returns http success' do
        get :index
        expect(response).to be_successful
      end
    end

    context 'user is not admin' do
      before { user.update(admin: false) }
      it 'throws a not authorised error' do
        expect { get :index }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'user is not signed-in' do
      before { sign_out user }
      it 'is not successful' do
        get :index
        expect(response).not_to be_successful
      end
    end
  end

  describe 'PATCH #recipe_approve' do
    let(:params) { { recipe_id: recipe.id } }
    context 'user is admin' do
      it 'updates the recipe state to approved' do
        expect(recipe.state).to eq('awaiting_approval')
        patch :recipe_approve, params: params
        expect(recipe.reload.state).to eq('approved')
      end

      it 'redirects to the admin index page' do
        patch :recipe_approve, params: params
        expect(response).to redirect_to admin_path
      end
    end

    context 'user is not admin' do
      before { user.update(admin: false) }
      it 'throws a not authorised error' do
        expect { patch :recipe_approve, params: params }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'user is not signed-in' do
      before { sign_out user }
      it 'does not call approve on the recipe' do
        expect(recipe).to receive(:approve).never
        patch :recipe_approve, params: params
      end

      it 'does not change the recipe state' do
        expect(recipe.state).to eq('awaiting_approval')
        patch :recipe_approve, params: params
        expect(recipe.reload.state).to eq('awaiting_approval')
      end
    end
  end

  describe 'PATCH #recipe_approve_for_feature' do
    let(:params) { { recipe_id: recipe.id } }
    context 'user is admin' do
      it 'updates the recipe state to approved_for_feature' do
        expect(recipe.state).to eq('awaiting_approval')
        patch :recipe_approve_for_feature, params: params
        expect(recipe.reload.state).to eq('approved_for_feature')
      end

      it 'redirects to the admin index page' do
        patch :recipe_approve_for_feature, params: params
        expect(response).to redirect_to admin_path
      end
    end

    context 'user is not admin' do
      before { user.update(admin: false) }
      it 'throws a not authorised error' do
        expect { patch :recipe_approve_for_feature, params: params }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'user is not signed-in' do
      before { sign_out user }
      it 'does not call approve_for_feature on the recipe' do
        expect(recipe).to receive(:approve_for_feature).never
        patch :recipe_approve_for_feature, params: params
      end

      it 'does not change the recipe state' do
        expect(recipe.state).to eq('awaiting_approval')
        patch :recipe_approve_for_feature, params: params
        expect(recipe.reload.state).to eq('awaiting_approval')
      end
    end
  end

  describe 'PATCH #recipe_approve_for_recipe_of_the_day' do
    let(:params) { { recipe_id: recipe.id } }
    context 'user is admin' do
      it 'updates the recipe state to approved_for_recipe_of_the_day' do
        expect(recipe.state).to eq('awaiting_approval')
        patch :recipe_approve_for_recipe_of_the_day, params: params
        expect(recipe.reload.state).to eq('approved_for_recipe_of_the_day')
      end

      it 'redirects to the admin index page' do
        patch :recipe_approve_for_recipe_of_the_day, params: params
        expect(response).to redirect_to admin_path
      end
    end

    context 'user is not admin' do
      before { user.update(admin: false) }
      it 'throws a not authorised error' do
        expect { patch :recipe_approve_for_recipe_of_the_day, params: params }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'user is not signed-in' do
      before { sign_out user }
      it 'does not call approve_for_recipe_of_the_day on the recipe' do
        expect(recipe).to receive(:approve_for_recipe_of_the_day).never
        patch :recipe_approve_for_recipe_of_the_day, params: params
      end

      it 'does not change the recipe state' do
        expect(recipe.state).to eq('awaiting_approval')
        patch :recipe_approve_for_recipe_of_the_day, params: params
        expect(recipe.reload.state).to eq('awaiting_approval')
      end
    end
  end

  describe 'PATCH #recipe_decline' do
    let(:params) { { recipe_id: recipe.id, recipe: { declined_reason: declined_reason } } }
    let(:declined_reason) { nil }
    context 'user is admin' do
      context 'declined reason is present' do
        let(:declined_reason) { 'No ready meals' }
        it 'updates the recipe state to declined' do
          expect(recipe.state).to eq('awaiting_approval')
          patch :recipe_decline, params: params
          expect(recipe.reload.state).to eq('declined')
        end

        it 'adds the declined reason' do
          expect(recipe.declined_reason).to eq(nil)
          patch :recipe_decline, params: params
          expect(recipe.reload.declined_reason).to eq('No ready meals')
        end

        it 'redirects to the admin index page' do
          patch :recipe_decline, params: params
          expect(response).to redirect_to admin_path
        end
      end

      context 'declined reason is an empty string' do
        let(:declined_reason) { '' }
        it 'does not update the state' do
          expect(recipe.state).to eq('awaiting_approval')
          patch :recipe_decline, params: params
          expect(recipe.reload.state).to eq('awaiting_approval')
        end

        it 'does not change the declined reason' do
          expect(recipe.declined_reason).to eq(nil)
          patch :recipe_decline, params: params
          expect(recipe.reload.declined_reason).to eq(nil)
        end

        it 'displays a flash message' do
          patch :recipe_decline, params: params
          expect(flash[:alert]).to eq('Fail. Declined reason should be present.')
        end

        it 'redirects to the admin index page' do
          patch :recipe_decline, params: params
          expect(response).to redirect_to admin_path
        end
      end

      context 'declined reason is nil' do
        it 'does not update the state' do
          expect(recipe.state).to eq('awaiting_approval')
          patch :recipe_decline, params: params
          expect(recipe.reload.state).to eq('awaiting_approval')
        end

        it 'does not change the declined reason' do
          expect(recipe.declined_reason).to eq(nil)
          patch :recipe_decline, params: params
          expect(recipe.reload.declined_reason).to eq(nil)
        end

        it 'displays a flash message' do
          patch :recipe_decline, params: params
          expect(flash[:alert]).to eq('Fail. Declined reason should be present.')
        end

        it 'redirects to the admin index page' do
          patch :recipe_decline, params: params
          expect(response).to redirect_to admin_path
        end
      end
    end

    context 'user is not admin' do
      before { user.update(admin: false) }
      it 'throws a not authorised error' do
        expect { patch :recipe_decline, params: params }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'user is not signed-in' do
      before { sign_out user }
      it 'does not call decline on the recipe' do
        expect(recipe).to receive(:decline).never
        patch :recipe_decline, params: params
      end

      it 'does not change the recipe state' do
        expect(recipe.state).to eq('awaiting_approval')
        patch :recipe_decline, params: params
        expect(recipe.reload.state).to eq('awaiting_approval')
      end
    end
  end
end

