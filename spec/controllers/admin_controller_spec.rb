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
      xit 'does not call approve on the recipe' do
        # FIX THIS
        # expect(recipe).to receive(:approve).never
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
      xit 'does not call approve_for_feature on the recipe' do
        # COMPLETE THIS
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
      xit 'does not call approve_for_recipe_of_the_day on the recipe' do
        # COMPLETE THIS
      end

      it 'does not change the recipe state' do
        expect(recipe.state).to eq('awaiting_approval')
        patch :recipe_approve_for_recipe_of_the_day, params: params
        expect(recipe.reload.state).to eq('awaiting_approval')
      end
    end
  end

  describe 'PATCH #recipe_decline' do
    let(:params) { { recipe_id: recipe.id } }
    context 'user is admin' do
      it 'updates the recipe state to declined' do
        expect(recipe.state).to eq('awaiting_approval')
        patch :recipe_decline, params: params
        expect(recipe.reload.state).to eq('declined')
      end

      it 'redirects to the admin index page' do
        patch :recipe_decline, params: params
        expect(response).to redirect_to admin_path
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
      xit 'does not call decline on the recipe' do
        # COMPLETE THIS
      end

      it 'does not change the recipe state' do
        expect(recipe.state).to eq('awaiting_approval')
        patch :recipe_decline, params: params
        expect(recipe.reload.state).to eq('awaiting_approval')
      end
    end
  end
end

